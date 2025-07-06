
import { expect } from "chai";
import { network } from "hardhat";

import fetch from 'node-fetch';
import { Wallet, getBytes, HDNodeWallet } from 'ethers';

import { generateRSAKeyPair, reconstructUserKey, decryptUint } from 'soda-sdk';


const { ethers } = await network.connect({network: "sepolia"});

const PROXY_URL = process.env.PROXY_URL || 'https://proxy.bubble.sodalabs.net';
const MNEMONIC = process.env.MNEMONIC;
if (!MNEMONIC) {
  throw new Error('MNEMONIC environment variable is required');
}

async function getUserKeyViaProxy(signer: Wallet | HDNodeWallet, proxyUrl: string) {
  const keys = generateRSAKeyPair();
  const signedEKString = await signer.signMessage(keys.publicKey);
  const signedEK = getBytes(signedEKString);
  const requestData = {
    rsa_public_key: Buffer.from(keys.publicKey).toString('base64'),
    user_signature: Buffer.from(signedEK).toString('base64'),
  };
  const response = await fetch(`${proxyUrl}/onboard`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(requestData),
  });
  if (!response.ok) {
    throw new Error(`Onboarding failed: ${await response.text()}`);
  }
  const result = (await response.json()) as { rsa_ciphertexts: string; message: string };
  const rsaCiphertexts = Buffer.from(result.rsa_ciphertexts, 'base64');
  const RSA_CIPHERTEXT_SIZE = 256;
  const encryptedKeyShare0 = rsaCiphertexts.slice(0, RSA_CIPHERTEXT_SIZE).toString('hex');
  const encryptedKeyShare1 = rsaCiphertexts.slice(RSA_CIPHERTEXT_SIZE).toString('hex');
  return reconstructUserKey(keys.privateKey, encryptedKeyShare0, encryptedKeyShare1);
}

async function decryptBalanceViaProxy(
  balanceHandle: bigint,
  signer: Wallet | HDNodeWallet,
  userAesKey: Buffer,
  proxyUrl: string
): Promise<bigint> {
  // Convert handle to bytes (32-byte big-endian)
  const handleHex = `0x${balanceHandle.toString(16).padStart(64, '0')}`;
  const handleBytes = getBytes(handleHex);

  // Sign the handle bytes
  const signature = await signer.signMessage(handleBytes);

  // Get chain ID from the provider
  const network = await ethers.provider.getNetwork();
  const chainId = Number(network.chainId);
  console.log('Chain ID:', chainId);
  const requestData = {
    handle: Buffer.from(handleBytes).toString('base64'),
    chain_id: chainId,
    user_signature: Buffer.from(getBytes(signature)).toString('base64'),
  };

  const response = await fetch(`${proxyUrl}/encrypt-to-user`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(requestData),
  });

  if (!response.ok) {
    throw new Error(`HTTP ${response.status}: ${await response.text()}`);
  }

  const data = (await response.json()) as any;
  const encryptedOutput = Buffer.from(data.output, 'base64');
  return decryptUint(BigInt('0x' + encryptedOutput.toString('hex')), userAesKey.toString('hex'));
}

const wallet = Wallet.fromPhrase(MNEMONIC);

describe('ShieldedToken', function () {
  let userAesKey: Buffer;
  let userAesKeyHex: string;
  let userAddress: string;
  let shieldedToken: any;
  let mockToken: any;
  let otherWallet: HDNodeWallet;

  before(async function () {
    // Setup main user
    userAesKey = await getUserKeyViaProxy(wallet, PROXY_URL);
    userAesKeyHex = userAesKey.toString('hex');
    console.log('User AES Key:', userAesKeyHex);
    userAddress = wallet.address;

    // Create another wallet for testing transfers
    otherWallet = Wallet.createRandom().connect(ethers.provider) as HDNodeWallet;

    // Deploy mock token
    console.log('Deploying mock token...');
    mockToken = await ethers.deployContract("ClearToken", ['ClearToken', 'TCT'], { gasLimit: 5_000_000 });
    await mockToken.waitForDeployment();

    console.log('Mock token deployed at:', await mockToken.getAddress());

    // Deploy private token
    shieldedToken = await ethers.deployContract('ShieldedToken', ['ssbtUSDC',
      'ssbtUSDC',
      await mockToken.getAddress()]
    );
    await shieldedToken.waitForDeployment();
    console.log('Deployed ShieldedToken at:', await shieldedToken.getAddress());
  });

  describe('Basic Token Information', function () {
    it('should have correct name, symbol and decimals', async function () {
      expect(await shieldedToken.name()).to.equal('ssbtUSDC');
      expect(await shieldedToken.symbol()).to.equal('ssbtUSDC');
      expect(await shieldedToken.decimals()).to.equal(5);
    });
  });

  describe('Shield/Unshield Operations', function () {
    const shieldAmount = 150n * 10n ** 18n; // 100 tokens with 18 decimals
    const expectedPrivateAmount = 150n * 10n ** 5n; // 100 tokens with 5 decimals

    beforeEach(async function () {
      // Mint tokens to user for each test
      await (await mockToken.mint(userAddress, shieldAmount, { gasLimit: 5_000_000 })).wait();
      // Approve the private token to spend mock tokens
      await (
        await mockToken.approve(await shieldedToken.getAddress(), shieldAmount, {
          gasLimit: 5_000_000,
        })
      ).wait();
      // wait 5 seconds to ensure the state is updated
      await new Promise(resolve => setTimeout(resolve, 5000));
    });

    it('should successfully unshield shielded tokens back to standard tokens', async function () {
      console.log('Shielded token address', await shieldedToken.getAddress());
      console.log('Clear token address', await mockToken.getAddress());

      console.log('Shielding tokens');
      await (await shieldedToken.shield(shieldAmount, { gasLimit: 5_000_000 })).wait();

      // Get balance before unshield
      await new Promise(resolve => setTimeout(resolve, 5000));
      const balanceBeforeHandle = await shieldedToken['balanceOf(address)'](userAddress);
      let balanceBefore = balanceBeforeHandle;
      if (balanceBeforeHandle !== 0n) {
        await new Promise(resolve => setTimeout(resolve, 5000));
        balanceBefore = await decryptBalanceViaProxy(
          balanceBeforeHandle,
          wallet,
          userAesKey,
          PROXY_URL
        );
      }
      expect(balanceBefore).to.equal(expectedPrivateAmount);
      console.log('Shielding complete');
      // Store mock token balance before unshield
      const mockTokenBalanceBefore = await mockToken.balanceOf(userAddress);

      // Store the current block number before unshield
      const startBlock = await ethers.provider.getBlockNumber();

      // Request unshield
      console.log('Unshielding tokens');
      const unshieldTx = await shieldedToken.unshield(expectedPrivateAmount, {
        gasLimit: 5_000_000,
      });
      const unshieldReceipt = await unshieldTx.wait();
      expect(unshieldReceipt).to.not.be.undefined;
      await new Promise(resolve => setTimeout(resolve, 5000));

      // Check UnshieldRequested event from the start block
      console.log('Asserting UnshieldRequested event');
      const requestFilter = shieldedToken.filters.UnshieldRequested;
      const requestEvents = await shieldedToken.queryFilter(requestFilter, startBlock);
      expect(requestEvents.length).to.be.greaterThan(0);
      expect(requestEvents[0].args[0]).to.equal(userAddress); // 'to' address
      expect(requestEvents[0].args[1]).to.equal(expectedPrivateAmount); // amount
      // Wait for callback to be processed with a timeout
      const maxWaitTime = 30000; // 30 seconds
      const checkInterval = 2000; // 2 seconds
      let successEvents: any[] = [];
      let failedEvents: any[] = [];
      let successDecryptionEvents: any[] = [];

      const startTime = Date.now();
      console.log('Checking for Unshield events');
      while (Date.now() - startTime < maxWaitTime) {
        // Check all relevant events from the start block
        successEvents = await shieldedToken.queryFilter(shieldedToken.filters.Unshield, startBlock);
        failedEvents = await shieldedToken.queryFilter(
          shieldedToken.filters.UnshieldFailed,
          startBlock
        );
        successDecryptionEvents = await shieldedToken.queryFilter(
          shieldedToken.filters.SuccessDecryption,
          startBlock
        );

        // If we have either a success or failure event, break the loop
        if (successEvents.length > 0 || failedEvents.length > 0) {
          break;
        }

        // Wait for the next check interval
        console.log('Waiting for next check interval');
        await new Promise(resolve => setTimeout(resolve, checkInterval));
      }

      // We expect a successful unshield
      expect(successEvents.length, 'Expected successful unshield event').to.be.greaterThan(0);
      expect(failedEvents.length, 'Expected no failed unshield events').to.equal(0);

      // Check mock token balance difference matches the unshield amount
      const mockTokenBalanceAfter = await mockToken.balanceOf(userAddress);
      const balanceDifference = mockTokenBalanceAfter - mockTokenBalanceBefore;
      expect(
        balanceDifference,
        'Mock token balance difference should match shield amount'
      ).to.equal(shieldAmount);

      // Check total supply reduced
      expect(await shieldedToken.totalSupply()).to.equal(0);

      // Check user's private balance is zero
      const balanceHandle = await shieldedToken['balanceOf(address)'](userAddress);
      let decryptedBalance = balanceHandle;
      if (balanceHandle !== 0n) {
        decryptedBalance = await decryptBalanceViaProxy(
          balanceHandle,
          wallet,
          userAesKey,
          PROXY_URL
        );
      }
      expect(decryptedBalance).to.equal(0n);
    });
  });

  describe('Transfer Operations', function () {
    const shieldAmount = 100n * 10n ** 18n; // 100 tokens with 18 decimals
    const transferAmount = 50n * 10n ** 5n; // 50 tokens with 5 decimals

    beforeEach(async function () {
      // Mint and shield tokens for transfer tests
      console.log('Minting...');
      await (await mockToken.mint(userAddress, shieldAmount, { gasLimit: 5_000_000 })).wait();
      console.log('approving...');
      await (
        await mockToken.approve(await shieldedToken.getAddress(), shieldAmount, {
          gasLimit: 5_000_000,
        })
      ).wait();
      console.log('shielding...');
      await (await shieldedToken.shield(shieldAmount, { gasLimit: 5_000_000 })).wait();
      // wait 5 seconds to ensure the state is updated
      await new Promise(resolve => setTimeout(resolve, 5000));
      // Check sender's balance
      const senderBalanceHandle = await shieldedToken['balanceOf(address)'](userAddress);
      console.log(senderBalanceHandle);
      const senderBalance = await decryptBalanceViaProxy(
        senderBalanceHandle,
        wallet,
        userAesKey,
        PROXY_URL
      );
      console.log(senderBalance);
    });

    it('should successfully transfer private tokens using clear value', async function () {
      // Transfer to other wallet
      const transferTx = await shieldedToken['transfer(address,uint64)'](
        otherWallet.address,
        Number(transferAmount)
      );
      await transferTx.wait();
      console.log('Transfer transaction hash:', transferTx.hash);

      // Check sender's balance
      const senderBalanceHandle = await shieldedToken['balanceOf(address)'](wallet.address);
      console.log(senderBalanceHandle);

      const senderBalance = await decryptBalanceViaProxy(
        senderBalanceHandle,
        wallet,
        userAesKey,
        PROXY_URL
      );
      expect(senderBalance).to.equal(100n * 10n ** 5n); // 100 tokens remaining
    });
  });
});
