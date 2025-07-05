import { ethers } from "hardhat";
import { input, inputAddress } from "./utils";

async function main() {
  let factoryAddress = await inputAddress("Enter the shielded token factory address: ");
  let tokenName = await input("Enter the shielded token name: ");
  let tokenSymbol = await input("Enter the shielded token symbol: ");
  let underlying = await inputAddress("Enter the underlying token address: ");

  const Factory = await ethers.getContractFactory("ShieldedTokenFactory");
  const factory = Factory.attach(factoryAddress);

  // Check if the contract exists at the given address
  const code = await ethers.provider.getCode(factoryAddress);
  if (code === "0x") {
    throw new Error(`No contract found at address ${factoryAddress}`);
  }
  
  try {
    const tx = await (factory as any).createToken(tokenName, tokenSymbol, underlying);
    const receipt = await tx.wait(2); // Wait for 2 confirmations
    if (receipt && receipt.logs) {
      // Find the TokenCreated event
      const event = receipt.logs
        .map((log: any) => {
          try {
            return factory.interface.parseLog(log);
          } catch {
            return null;
          }
        })
        .find((e: any) => e && e.name === "TokenCreated");
      if (event) {
        const tokenAddress = event.args.token;
        console.log(`✅ Token created!`);
        console.log(`  Name:    ${tokenName}`);
        console.log(`  Symbol:  ${tokenSymbol}`);
        console.log(`  Address: ${tokenAddress}`);
        console.log(`  Underlying: ${underlying}`);
      } else {
        console.log("⚠️  TokenCreated event not found in transaction receipt.");
      }
    } else {
      console.log("⚠️  No receipt or logs found for createToken transaction.");
    }
  } catch (err) {
    console.error("❌ Failed to create token via factory:", err);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Script failed:", error);
    process.exit(1);
  }); 