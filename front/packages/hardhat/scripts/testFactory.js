const { ethers } = require("hardhat");

async function main() {
  console.log("Testing SodaLabs PrivateERC20Factory connection...");
  
  const factoryAddress = "0x7e58A85165722785AE9CeaDa3D8c2188DCEADDAb";
  
  // Factory ABI (minimal)
  const factoryABI = [
    "function totalTokensCreated() view returns (uint256)",
    "function isTokenFromFactory(address token) view returns (bool)"
  ];
  
  try {
    // Get the factory contract
    const factory = new ethers.Contract(factoryAddress, factoryABI, ethers.provider);
    
    // Test connection by calling totalTokensCreated
    const totalTokens = await factory.totalTokensCreated();
    console.log(`✅ Factory connection successful!`);
    console.log(`📊 Total tokens created: ${totalTokens.toString()}`);
    
    // Get network info
    const network = await ethers.provider.getNetwork();
    console.log(`🌐 Connected to network: ${network.name} (Chain ID: ${network.chainId})`);
    
    // Get current block
    const blockNumber = await ethers.provider.getBlockNumber();
    console.log(`📦 Current block: ${blockNumber}`);
    
  } catch (error) {
    console.error("❌ Factory connection failed:");
    console.error(error.message);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });