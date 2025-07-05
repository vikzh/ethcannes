import { ethers } from 'hardhat';
import { input } from './utils';

async function main() {
  try {
    console.log('🚀 Deploying ERC20 token...\n');

    const tokenName = await input('Enter the token name: ');
    const tokenSymbol = await input('Enter the token symbol: ');

    console.log(`\n📋 Deployment parameters:`);
    console.log(`- Token Name: ${tokenName}`);
    console.log(`- Token Symbol: ${tokenSymbol}`);

    const [deployer] = await ethers.getSigners();
    console.log(`Deploying contracts with account: ${deployer.address}`);
    console.log(`Account balance: ${ethers.formatEther(await ethers.provider.getBalance(deployer.address))} ETH\n`);

    const ContractFactory = await ethers.getContractFactory('ClearToken');
    const token = await ContractFactory.deploy(
      tokenName,
      tokenSymbol
    );

    console.log('⏳ Waiting for deployment...');
    await token.waitForDeployment();

    const deployedAddress = await token.getAddress();
    console.log('✅ ERC20 token deployed successfully!');
    console.log(`📍 Contract address: ${deployedAddress}`);

    // Try to verify the deployment by checking token details
    try {
      console.log('\n🔍 Verifying deployment...');
      const verifyToken = ContractFactory.attach(deployedAddress);
      const deployedName = await (verifyToken as any).name();
      const deployedSymbol = await (verifyToken as any).symbol();
      const deployedSupply = await (verifyToken as any).totalSupply();
      const deployedDecimals = await (verifyToken as any).decimals();

      console.log(`✅ Token details verified:`);
      console.log(`- Name: ${deployedName}`);
      console.log(`- Symbol: ${deployedSymbol}`);
      console.log(`- Total Supply: ${ethers.formatUnits(deployedSupply, deployedDecimals)}`);
      console.log(`- Decimals: ${deployedDecimals}`);

      console.log('\n📝 Deployment Summary:');
      console.log(`- ERC20 Token: ${deployedAddress}`);
      console.log(`- Owner: ${deployer.address}`);
      console.log(`- Initial Supply: ${ethers.formatUnits(deployedSupply, deployedDecimals)} ${deployedSymbol}`);
      console.log(`- Constructor minted to deployer: ${ethers.formatUnits(deployedSupply, deployedDecimals)} ${deployedSymbol}`);
    } catch (verifyError: any) {
      console.log('⚠️  Could not verify token details, but deployment was successful');
      console.log('⚠️  This might be due to network delays or indexing issues');
      
      console.log('\n📝 Deployment Summary:');
      console.log(`- ERC20 Token: ${deployedAddress}`);
      console.log(`- Owner: ${deployer.address}`);
    }

  } catch (error) {
    console.error('❌ Deployment failed:', error);
    process.exit(1);
  }
}

// Execute the deployment
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
