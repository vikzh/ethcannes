import { ethers } from 'hardhat';
import { inputAddress, input } from './utils';

async function main() {
  try {
    console.log('🪙 Minting ERC20 tokens...\n');

    const tokenAddress = await inputAddress('Enter the ERC20 token address: ');
    const recipientAddress = await inputAddress('Enter the recipient address: ');
    const mintAmount = await input('Enter the amount to mint: ');

    console.log(`\n📋 Mint parameters:`);
    console.log(`- Token Address: ${tokenAddress}`);
    console.log(`- Recipient: ${recipientAddress}`);
    console.log(`- Amount: ${mintAmount} tokens\n`);

    const [signer] = await ethers.getSigners();
    console.log(`Minting with account: ${signer.address}`);
    console.log(`Account balance: ${ethers.formatEther(await ethers.provider.getBalance(signer.address))} ETH\n`);

    // Get the contract factory and attach to the deployed contract
    const ContractFactory = await ethers.getContractFactory('ClearToken');
    const token = ContractFactory.attach(tokenAddress);

    // Check if the contract exists at the given address
    const code = await ethers.provider.getCode(tokenAddress);
    if (code === "0x") {
      throw new Error(`No contract found at address ${tokenAddress}`);
    }

    // Parse the mint amount to the correct decimals
    const decimals = await (token as any).decimals();
    const mintAmountWei = ethers.parseUnits(mintAmount, decimals);

    console.log('⏳ Minting tokens...');
    const mintTx = await (token as any).mint(recipientAddress, mintAmountWei);
    await mintTx.wait();

    console.log('✅ Tokens minted successfully!');
    console.log(`📍 Transaction hash: ${mintTx.hash}`);

    // Verify the mint by checking recipient balance
    try {
      const recipientBalance = await (token as any).balanceOf(recipientAddress);
      const totalSupply = await (token as any).totalSupply();
      
      console.log(`\n🔍 Post-mint details:`);
      console.log(`- Recipient Balance: ${ethers.formatUnits(recipientBalance, decimals)}`);
      console.log(`- Total Supply: ${ethers.formatUnits(totalSupply, decimals)}`);
    } catch (verifyError) {
      console.log('⚠️  Could not verify mint (but transaction was successful)');
    }

    console.log('\n📝 Mint Summary:');
    console.log(`- Token: ${tokenAddress}`);
    console.log(`- Recipient: ${recipientAddress}`);
    console.log(`- Amount Minted: ${mintAmount} tokens`);
    console.log(`- Minter: ${signer.address}`);

  } catch (error) {
    console.error('❌ Minting failed:', error);
    process.exit(1);
  }
}

// Execute the minting
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  }); 