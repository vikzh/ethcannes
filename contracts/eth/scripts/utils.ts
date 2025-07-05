import { ethers } from 'hardhat';
import * as readline from 'readline';

/**
 * Prompts the user to input an Ethereum address and validates it
 * @param question - The question to ask the user
 * @returns Promise<string> - The validated Ethereum address
 */
export async function inputAddress(question: string = 'Enter an Ethereum address: '): Promise<string> {
  const address = await input(question);
  
  if (!ethers.isAddress(address)) {
    throw new Error('Invalid Ethereum address provided');
  }

  if (address === ethers.ZeroAddress) {
    throw new Error('Invalid Ethereum address provided');
  }

  return address;
}

/**
 * Prompts the user to input a string
 * @param question - The question to ask the user
 * @returns Promise<string> - The user's input
 */
export async function input(question: string = 'Enter input: '): Promise<string> {
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  });

  return new Promise((resolve) => {
    rl.question(question, (answer) => {
      rl.close();
      resolve(answer);
    });
  });
}
