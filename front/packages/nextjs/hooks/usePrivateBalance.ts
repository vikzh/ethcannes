import { useState, useEffect, useCallback } from "react";
import { useAccount } from "wagmi";
import { Address, parseAbi, getContract } from "viem";
import { usePublicClient } from "wagmi";

// MPC proxy service URL
const MPC_PROXY_URL = process.env.NEXT_PUBLIC_SODLABS_PROXY_URL || "https://proxy.bubble.sodalabs.net";

export type BalanceState = {
  encrypted: string | null;
  decrypted: string | null;
  isDecrypting: boolean;
  error: string | null;
};

export const usePrivateBalance = (tokenAddress: Address | undefined) => {
  const { address: userAddress } = useAccount();
  const publicClient = usePublicClient();
  
  const [balanceState, setBalanceState] = useState<BalanceState>({
    encrypted: null,
    decrypted: null,
    isDecrypting: false,
    error: null,
  });

  // Private token ABI for balance reading
  const privateTokenAbi = parseAbi([
    "function balanceOf() view returns (bytes)",
    "event Balance(address indexed _owner, bytes _balance)",
  ]);

  // Fetch encrypted balance from contract
  const fetchEncryptedBalance = useCallback(async () => {
    if (!tokenAddress || !userAddress || !publicClient) return;

    try {
      const contract = getContract({
        address: tokenAddress,
        abi: privateTokenAbi,
        client: publicClient,
      });

      const encryptedBalance = await contract.read.balanceOf();
      
      setBalanceState(prev => ({
        ...prev,
        encrypted: encryptedBalance as string,
        error: null,
      }));

      return encryptedBalance;
    } catch (error) {
      console.error("Failed to fetch encrypted balance:", error);
      setBalanceState(prev => ({
        ...prev,
        error: "Failed to fetch balance",
      }));
    }
  }, [tokenAddress, userAddress, publicClient]);

  // Decrypt balance via MPC proxy
  const decryptBalance = useCallback(async (userKey?: string) => {
    if (!balanceState.encrypted) {
      await fetchEncryptedBalance();
      return;
    }

    setBalanceState(prev => ({ ...prev, isDecrypting: true, error: null }));

    try {
      // TODO: Implement actual MPC decryption
      // For now, return a placeholder since we need the actual user key management
      const response = await fetch(`${MPC_PROXY_URL}/decrypt`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          encryptedBalance: balanceState.encrypted,
          userKey: userKey || "placeholder",
          userAddress,
        }),
      });

      if (!response.ok) {
        throw new Error("Failed to decrypt balance");
      }

      const { decryptedBalance } = await response.json();

      setBalanceState(prev => ({
        ...prev,
        decrypted: decryptedBalance,
        isDecrypting: false,
      }));

      return decryptedBalance;
    } catch (error) {
      console.error("Failed to decrypt balance:", error);
      setBalanceState(prev => ({
        ...prev,
        isDecrypting: false,
        error: "Failed to decrypt balance",
      }));
    }
  }, [balanceState.encrypted, userAddress, fetchEncryptedBalance]);

  // Auto-fetch encrypted balance when dependencies change
  useEffect(() => {
    if (tokenAddress && userAddress) {
      fetchEncryptedBalance();
    }
  }, [tokenAddress, userAddress, fetchEncryptedBalance]);

  // Refresh both encrypted and decrypted balance
  const refreshBalance = useCallback(async (userKey?: string) => {
    await fetchEncryptedBalance();
    if (userKey) {
      await decryptBalance(userKey);
    }
  }, [fetchEncryptedBalance, decryptBalance]);

  // Clear balance state
  const clearBalance = useCallback(() => {
    setBalanceState({
      encrypted: null,
      decrypted: null,
      isDecrypting: false,
      error: null,
    });
  }, []);

  // Format balance for display (considering 5 decimal precision)
  const formatBalance = useCallback((balance: string | null) => {
    if (!balance) return "0.00000";
    
    try {
      const num = parseFloat(balance);
      return num.toFixed(5);
    } catch {
      return "0.00000";
    }
  }, []);

  return {
    // Balance state
    ...balanceState,
    
    // Computed values
    formattedBalance: formatBalance(balanceState.decrypted),
    hasEncryptedBalance: !!balanceState.encrypted,
    hasDecryptedBalance: !!balanceState.decrypted,
    
    // Actions
    fetchEncryptedBalance,
    decryptBalance,
    refreshBalance,
    clearBalance,
    
    // Utilities
    formatBalance,
  };
};

export default usePrivateBalance;