import { expect } from "chai";
import hre from "hardhat";
import fetch from "node-fetch";
import { Wallet, getBytes, HDNodeWallet } from "ethers";
import dotenv from "dotenv";

import {
  generateRSAKeyPair,
  reconstructUserKey,
  decryptUint
} from "soda-sdk";

import {ShieldedToken} from "../typechain-types";
import {prepareMessageForBubble} from "./utils";

dotenv.config();

const PROXY_URL = process.env.PROXY_URL || "https://proxy.bubble.sodalabs.net";
const MNEMONIC = process.env.MNEMONIC;
if (!MNEMONIC) {
  throw new Error("MNEMONIC environment variable is required");
}

const wallet = Wallet.fromPhrase(MNEMONIC);

async function getUserKeyViaProxy(signer: Wallet | HDNodeWallet, proxyUrl: string) {
  const keys = generateRSAKeyPair();
  const signedEKString = await signer.signMessage(keys.publicKey);
  const signedEK = getBytes(signedEKString);
  const requestData = {
    rsa_public_key: Buffer.from(keys.publicKey).toString("base64"),
    user_signature: Buffer.from(signedEK).toString("base64"),
  };
  const response = await fetch(`${proxyUrl}/onboard`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(requestData),
  });
  if (!response.ok) {
    throw new Error(`Onboarding failed: ${await response.text()}`);
  }
  const result = (await response.json()) as { rsa_ciphertexts: string; message: string };
  const rsaCiphertexts = Buffer.from(result.rsa_ciphertexts, "base64");
  const RSA_CIPHERTEXT_SIZE = 256;
  const encryptedKeyShare0 = rsaCiphertexts.slice(0, RSA_CIPHERTEXT_SIZE).toString("hex");
  const encryptedKeyShare1 = rsaCiphertexts.slice(RSA_CIPHERTEXT_SIZE).toString("hex");
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
  const network = await hre.ethers.provider.getNetwork();
  const chainId = Number(network.chainId);
  console.log("Chain ID:", chainId);
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

  const data = await response.json() as any;
  const encryptedOutput = Buffer.from(data.output, 'base64');
  return decryptUint(
    BigInt('0x' + encryptedOutput.toString('hex')),
    userAesKey.toString('hex')
  );
}

describe("ShieldedToken", function () {
  let userAesKey: Buffer;
  let userAesKeyHex: string;
  let userAddress: string;
  let shieldedToken: ShieldedToken;
  let mockToken: any;
  let otherWallet: HDNodeWallet;

  before(async function () {
    // Setup main user
    userAesKey = await getUserKeyViaProxy(wallet, PROXY_URL);
    userAesKeyHex = userAesKey.toString("hex");
    console.log("User AES Key:", userAesKeyHex);
    userAddress = wallet.address;

    // Create another wallet for testing transfers
    otherWallet = Wallet.createRandom().connect(hre.ethers.provider) as HDNodeWallet;

    // Deploy mock token
    console.log("Deploying mock token...");
    const MockTokenFactory = await hre.ethers.getContractFactory("ClearToken");
    mockToken = await MockTokenFactory.deploy("ClearToken", "TCT");
    await mockToken.waitForDeployment();
    console.log("Mock token deployed at:", await mockToken.getAddress());

    // Deploy private token
    const ContractFactory = await hre.ethers.getContractFactory("ShieldedToken");
    shieldedToken = await ContractFactory.deploy("ssbtUSDC", "ssbtUSDC", await mockToken.getAddress());
    await shieldedToken.waitForDeployment();
    console.log("Deployed ShieldedToken at:", await shieldedToken.getAddress());
  });

  describe("Basic Token Information", function () {
    it("should have correct name, symbol and decimals", async function () {
      expect(await shieldedToken.name()).to.equal("ssbtUSDC");
      expect(await shieldedToken.symbol()).to.equal("ssbtUSDC");
      expect(await shieldedToken.decimals()).to.equal(5);
    });
  });

  describe("Transfer Operations", function () {
    const shieldAmount = 100n * 10n ** 18n; // 100 tokens with 18 decimals
    const transferAmount = 50n * 10n ** 5n; // 50 tokens with 5 decimals

    beforeEach(async function () {
      // Mint and shield tokens for transfer tests
      console.log("Minting...");
      await (await mockToken.mint(userAddress, shieldAmount, { gasLimit: 5_000_000 })).wait();
      console.log("approving...");
      await (await mockToken.approve(await shieldedToken.getAddress(), shieldAmount, { gasLimit: 5_000_000 })).wait();
      console.log("shielding...");
      await (await shieldedToken.shield(shieldAmount, { gasLimit: 5_000_000 })).wait();
      // wait 5 seconds to ensure the state is updated
      await new Promise(resolve => setTimeout(resolve, 5000));
      // Check sender's balance
      const senderBalanceHandle = await shieldedToken["balanceOf(address)"](userAddress);
      console.log(senderBalanceHandle)
      const senderBalance = await decryptBalanceViaProxy(senderBalanceHandle, wallet, userAesKey, PROXY_URL);
      console.log(senderBalance)
    });

    it.only("should successfully transfer private tokens using clear value", async function () {
      // Transfer to other wallet
      const transferTx = await shieldedToken["transfer(address,uint64)"](otherWallet.address, Number(transferAmount));
      await transferTx.wait();
      console.log("Transfer transaction hash:", transferTx.hash);

      // Check sender's balance
      const senderBalanceHandle = await shieldedToken["balanceOf(address)"](userAddress);
      console.log(senderBalanceHandle)

      const senderBalance = await decryptBalanceViaProxy(senderBalanceHandle, wallet, userAesKey, PROXY_URL);
      expect(senderBalance).to.equal(100n * 10n ** 5n); // 100 tokens remaining
    });

  });

}); 