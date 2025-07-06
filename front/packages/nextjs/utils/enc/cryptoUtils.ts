import { ethers } from "ethers";
import { decryptUint, generateRSAKeyPair, reconstructUserKey } from "soda-sdk";
import { WalletApiService } from "../../services/wallet/walletApiService";

/**
 * Crypto utility functions for wallet operations
 */

export const CRYPTO_CONSTANTS = {
  RSA_CIPHERTEXT_SIZE: 256,
} as const;

/**
 * Get stored user key from localStorage
 */
export const getUserKeyFromStorage = (): string | null => {
  return localStorage.getItem("aesKey");
};

/**
 * Store user key in localStorage
 */
export const storeUserKey = (key: string): void => {
  localStorage.setItem("aesKey", key);
};

/**
 * Safely format private balance
 */
export const formatPrivateBalance = (balance: string | null, decimals: number | null): string => {
  try {
    if (!balance || decimals === null) return "Error loading balance";
    return ethers.formatUnits(BigInt(balance), decimals);
  } catch (err) {
    console.error("Error formatting balance:", err);
    return "Error formatting balance";
  }
};

/**
 * Decrypt balance via proxy using MPC
 */
export const decryptBalanceViaProxy = async (
  balanceHandle: bigint,
  signer: ethers.Signer,
  userAesKey: string,
): Promise<bigint> => {
  
  // Convert handle to bytes (32-byte big-endian)
  const handleHex = `0x${balanceHandle.toString(16).padStart(64, "0")}`;
  const handleBytes = ethers.getBytes(handleHex);

  // Sign a base-64 string representation of the handle so that the wallet popup shows readable text
  const handleBase64 = Buffer.from(handleBytes).toString("base64");
  const signature = await signer.signMessage(handleBase64);

  // Get chain ID from the provider
  const network = await signer.provider?.getNetwork();
  const chainId = Number(network?.chainId || 0);

  // Prepare request data
  const handle = Buffer.from(handleBytes).toString("base64");
  const userSignature = Buffer.from(ethers.getBytes(signature)).toString("base64");


  // Call API service
  const encryptedOutput = await WalletApiService.decryptBalance(handle, chainId, userSignature);
  const encryptedOutputBuffer = Buffer.from(encryptedOutput, "base64");
  const result = decryptUint(BigInt("0x" + encryptedOutputBuffer.toString("hex")), userAesKey);
    
  return result;
};

/**
 * Complete onboarding process
 */
export const completeOnboarding = async (signer: ethers.Signer): Promise<string> => {
  // 1. Generate RSA key pair
  const { publicKey, privateKey } = await generateRSAKeyPair();

  // 2. Sign the public key with the connected wallet
  const publicKeyBytes = new Uint8Array(publicKey instanceof Uint8Array ? publicKey : Uint8Array.from(publicKey));
  // Sign a base-64 string so MetaMask shows readable text
  const publicKeyBase64 = Buffer.from(publicKeyBytes).toString("base64");
  const signedEKString = await signer.signMessage(publicKeyBase64);
  const signedEK = ethers.getBytes(signedEKString);

  // 3. Prepare request data
  const rsaPublicKey = Buffer.from(publicKeyBytes).toString("base64");
  const userSignature = Buffer.from(signedEK).toString("base64");

  // 4. Call onboarding service
  const result = await WalletApiService.onboardUser(rsaPublicKey, userSignature);
  
  // 5. Process response
  const rsaCiphertexts = Buffer.from(result.rsa_ciphertexts, "base64");
  const encryptedKeyShare0 = rsaCiphertexts.slice(0, CRYPTO_CONSTANTS.RSA_CIPHERTEXT_SIZE).toString("hex");
  const encryptedKeyShare1 = rsaCiphertexts.slice(CRYPTO_CONSTANTS.RSA_CIPHERTEXT_SIZE).toString("hex");

  // 6. Reconstruct user key
  const decryptedAESKey = reconstructUserKey(privateKey, encryptedKeyShare0, encryptedKeyShare1);
  const aesKeyHex = decryptedAESKey.toString("hex");

  storeUserKey(aesKeyHex);

  return aesKeyHex;
};

/**
 * Validate Ethereum address
 */
export const isValidAddress = (address: string): boolean => {
  return address.length > 0 && ethers.isAddress(address);
}; 