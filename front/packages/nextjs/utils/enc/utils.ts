import { decryptUint, generateRSAKeyPair, reconstructUserKey } from "soda-sdk";
import { WalletApiService } from "../../services/wallet/walletApiService";
import { type Config } from "wagmi";
import { signMessage } from "wagmi/actions";
import { ethers } from "ethers";

export const CRYPTO_CONSTANTS = {
  RSA_CIPHERTEXT_SIZE: 256,
} as const;

// Storage functions remain the same
export const getUserKeyFromStorage = (): string | null => {
  return localStorage.getItem("aesKey");
};

export const storeUserKey = (key: string): void => {
  localStorage.setItem("aesKey", key);
};

export const formatPrivateBalance = (balance: string | null, decimals: number | null): string => {
  try {
    if (!balance || decimals === null) return "Error loading balance";
    return ethers.formatUnits(BigInt(balance), decimals);
  } catch (err) {
    console.error("Error formatting balance:", err);
    return "Error formatting balance";
  }
};

// Wagmi-based balance decryption
export const decryptBalanceViaProxyWagmi = async (
  balanceHandle: bigint,
  address: string,
  wagmiConfig: Config,
  userAesKey: string,
): Promise<bigint> => {
  // Convert handle to bytes (32-byte big-endian)
  const handleHex = `0x${balanceHandle.toString(16).padStart(64, "0")}`;
  const handleBytes = new Uint8Array(Buffer.from(handleHex.slice(2), 'hex'));

  // Sign the handle bytes using wagmi
  const signature = await signMessage(wagmiConfig, {
    account: address,
    message: handleBytes,
  });

  // Get chain ID from wagmi config
  const chainId = wagmiConfig.chains[0]?.id || 0;

  // Prepare request data
  const handle = Buffer.from(handleBytes).toString("base64");
  const userSignature = Buffer.from(signature.slice(2), 'hex').toString("base64");

  // Call API service
  const encryptedOutput = await WalletApiService.decryptBalance(handle, chainId, userSignature);
  const encryptedOutputBuffer = Buffer.from(encryptedOutput, "base64");
  const result = decryptUint(BigInt("0x" + encryptedOutputBuffer.toString("hex")), userAesKey);
    
  return result;
};

// Wagmi-based onboarding
export const completeOnboardingWagmi = async (
  address: string,
  wagmiConfig: Config
): Promise<string> => {
  // 1. Generate RSA key pair
  const { publicKey, privateKey } = await generateRSAKeyPair();

  // 2. Sign the public key with the connected wallet using wagmi
  const publicKeyBytes = new Uint8Array(publicKey instanceof Uint8Array ? publicKey : Uint8Array.from(publicKey));
  const signedEK = await signMessage(wagmiConfig, {
    account: address,
    message: publicKeyBytes,
  });

  // 3. Prepare request data
  const rsaPublicKey = Buffer.from(publicKeyBytes).toString("base64");
  const userSignature = Buffer.from(signedEK.slice(2), 'hex').toString("base64");

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

export const isValidAddress = (address: string): boolean => {
  return address.length > 0 && ethers.isAddress(address);
};