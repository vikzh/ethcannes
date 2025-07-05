import { decryptUint, generateRSAKeyPair, reconstructUserKey } from "soda-sdk";
import { type Config } from "wagmi";
import { signMessage } from "wagmi/actions";
import { ethers } from "ethers";

export const getUserKey = (address?: string): string | null => {
  // If an address is provided, use address-scoped storage. Fallback to legacy key for backward-compat.
  if (address) {
    return localStorage.getItem(`aesKey_${address.toLowerCase()}`);
  }
  return localStorage.getItem("aesKey");
};

export const storeUserKey = (key: string, address?: string): void => {
  // Persist AES key under the connected wallet address, leave legacy key path for compatibility.
  if (address) {
    localStorage.setItem(`aesKey_${address.toLowerCase()}`, key);
  } else {
  localStorage.setItem("aesKey", key);
  }
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

export const decryptBalance = async (
  balanceHandle: bigint,
  address: string,
  wagmiConfig: Config,
  userAesKey: string,
): Promise<bigint> => {
  // Convert handle to bytes (32-byte big-endian)
  const handleHex = `0x${balanceHandle.toString(16).padStart(64, "0")}`;
  // Pass as hex string to signMessage
  const signature = await signMessage(wagmiConfig, {
    account: address,
    message: handleHex,
  });

  const chainId = wagmiConfig.chains[0]?.id || 0;

  const handle = Buffer.from(handleHex.slice(2), 'hex').toString("base64");
  const userSignature = Buffer.from(signature.slice(2), 'hex').toString("base64");

  // Call API service
  const encryptedOutput = await getBalanceHandle(handle, chainId, userSignature);
  const encryptedOutputBuffer = Buffer.from(encryptedOutput, "base64");
  const result = decryptUint(BigInt("0x" + encryptedOutputBuffer.toString("hex")), userAesKey);
    
  return result;
};

// Wagmi-based onboarding
export const completeOnboarding = async (
  address: string,
  wagmiConfig: Config
): Promise<string> => {
  // 1. Generate RSA key pair
  const { publicKey, privateKey } = await generateRSAKeyPair();

  // 2. Sign the public key with the connected wallet using wagmi
  const publicKeyBytes = new Uint8Array(publicKey instanceof Uint8Array ? publicKey : Uint8Array.from(publicKey));
  const publicKeyHex = '0x' + Buffer.from(publicKeyBytes).toString('hex');
  const signedEK = await signMessage(wagmiConfig, {
    account: address,
    message: publicKeyHex,
  });

  // 3. Prepare request data
  const rsaPublicKey = Buffer.from(publicKeyBytes).toString("base64");
  const userSignature = Buffer.from(signedEK.slice(2), 'hex').toString("base64");

  // 4. Call onboarding service (inlined onboardUser logic)
  const requestData = {
    rsa_public_key: rsaPublicKey,
    user_signature: userSignature,
  };

  const response = await fetch(`/api/onboard`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(requestData),
  });

  if (!response.ok) {
    const errorText = await response.text();
    throw new Error(`Onboarding failed: ${errorText}`);
  }

  const result = await response.json() as { rsa_ciphertexts: string; message: string };

  const rsaCiphertexts = Buffer.from(result.rsa_ciphertexts, "base64");
  const rsaCiphertextSize = 256;
  const encryptedKeyShare0 = rsaCiphertexts.slice(0, rsaCiphertextSize).toString("hex");
  const encryptedKeyShare1 = rsaCiphertexts.slice(rsaCiphertextSize).toString("hex");

  const decryptedAESKey = reconstructUserKey(privateKey, encryptedKeyShare0, encryptedKeyShare1);
  const aesKeyHex = decryptedAESKey.toString("hex");

  // Persist AES key scoped to user address
  storeUserKey(aesKeyHex, address);

  return aesKeyHex;
};

export const isValidAddress = (address: string): boolean => {
  return address.length > 0 && ethers.isAddress(address);
};

export const getBalanceHandle = async (
      handle: string,
      chainId: number,
      userSignature: string
    ): Promise<string> => {
      const requestData = {
        handle,
        chain_id: chainId,
        user_signature: userSignature,
      };
  
      const response = await fetch(`/api/encrypt-to-user`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(requestData),
      });
  
      if (!response.ok) {
        const errorText = await response.text();
        
        // Check for specific "unknown handle" error from MPC service
        if (errorText.includes("unknown handle") || errorText.includes("grpc_message:\"unknown handle\"")) {
          throw new Error("UNKNOWN_HANDLE: This balance handle is not recognized by the MPC service. You may need to perform a private token operation first (like shielding tokens) to initialize your private balance.");
        }
        
        throw new Error(`HTTP ${response.status}: ${errorText}`);
      }
  
      const data = (await response.json()) as { output: string };
      return data.output;
    };