import { useState } from "react";
import { ethers } from "ethers";
import { PRIVATE_TOKEN_ABI, getContractAddresses } from "../../config/contracts";
import { decryptBalanceViaProxy, getUserKeyFromStorage } from "../../utils/soda/cryptoUtils";
import { notification } from "~~/utils/scaffold-eth";
import { NetworkTokenData } from "./useMultiNetworkTokenData";

export const usePrivateBalance = () => {
  const [isRefreshingBalance, setIsRefreshingBalance] = useState(false);

  const fetchPrivateBalance = async (
    targetNetworkId: number,
    chainId: number,
    address: string | undefined,
    updateNetworkData: (networkId: number, updates: Partial<NetworkTokenData>) => void,
    privateTokenAddress?: string,
    updateTokenPair?: (privateAddress: string, updates: { privateTokenBalance?: string }) => void
  ) => {
    setIsRefreshingBalance(true);
    const userKey = getUserKeyFromStorage();
    const networkId = targetNetworkId || chainId;
    
    if (!address) {
      setIsRefreshingBalance(false);
      return;
    }
    
    if (!userKey) {
      notification.error("No user key found. Please onboard first.");
      setIsRefreshingBalance(false);
      return;
    }
    
    if (!privateTokenAddress) {
      notification.error("Private token address is required for decryption");
      setIsRefreshingBalance(false);
      return;
    }

    if (networkId !== chainId) {
      notification.warning("You can only decrypt balances on the currently connected network. Please switch networks first.");
      setIsRefreshingBalance(false);
      return;
    }

    try {
      if (!window.ethereum) throw new Error("No ethereum provider found");
      
      const provider = new ethers.BrowserProvider(window.ethereum);
      
      const signer = await provider.getSigner();
      const contract = new ethers.Contract(privateTokenAddress, PRIVATE_TOKEN_ABI, signer);

      const balanceHandle = await contract["balanceOf(address)"](address);
      
      if (BigInt(balanceHandle) === 0n) {
        if (updateTokenPair) {
          updateTokenPair(privateTokenAddress, { privateTokenBalance: "0" });
        } else {
          updateNetworkData(networkId, { privateTokenBalance: "0" });
        }
        notification.info("No private balance found. Shield some tokens first to create a private balance.");
        return;
      }

      const decryptedBalance = await decryptBalanceViaProxy(BigInt(balanceHandle), signer, userKey);

      if (updateTokenPair) {
        updateTokenPair(privateTokenAddress, { privateTokenBalance: decryptedBalance.toString() });
      } else {
        updateNetworkData(networkId, { privateTokenBalance: decryptedBalance.toString() });
      }
      
      notification.success("Balance decrypted successfully!");
    } catch (err: any) {
      notification.error("Failed to decrypt balance. This may occur if you haven't performed any private token operations yet.");
    } finally {
      setIsRefreshingBalance(false);
    }
  };

  return {
    fetchPrivateBalance,
    isRefreshingBalance,
  };
}; 