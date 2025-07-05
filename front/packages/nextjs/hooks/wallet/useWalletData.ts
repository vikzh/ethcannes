import { useState } from "react";
import { useAccount, useChainId } from "wagmi";
import {
  useMultiNetworkTokenData,
  usePrivateBalance,
  useOnboarding,
  useTokenPairs,
  SUPPORTED_NETWORKS,
} from "../mpc";

export const useWalletData = () => {
  const { address, isConnected } = useAccount();
  const chainId = useChainId();

  // Data hooks from existing MPC layer
  const { networkTokenData, updateNetworkData, isLoading } = useMultiNetworkTokenData(address, chainId);
  const { fetchPrivateBalance, isRefreshingBalance } = usePrivateBalance();
  const { handleOnboard, onboardError } = useOnboarding();

  // Network filter state
  const [activeNetworks, setActiveNetworks] = useState<Set<number>>(new Set(SUPPORTED_NETWORKS));
  const { filteredTokenPairs, updateTokenPairBalance } = useTokenPairs(networkTokenData, activeNetworks, address);

  const toggleNetwork = (networkId: number) => {
    setActiveNetworks(prev => {
      const next = new Set(prev);
      if (next.has(networkId)) next.delete(networkId);
      else next.add(networkId);
      return next;
    });
  };

  const handlePrivateBalanceDecrypt = (targetChainId: number, privateTokenAddress?: string) => {
    fetchPrivateBalance(targetChainId, chainId, address, updateNetworkData, privateTokenAddress, updateTokenPairBalance);
  };

  const handleOnboardClick = () => handleOnboard(address);

  return {
    address,
    isConnected,
    chainId,
    activeNetworks,
    toggleNetwork,
    networkTokenData,
    filteredTokenPairs,
    updateNetworkData,
    updateTokenPairBalance,
    isLoading,
    isRefreshingBalance,
    handlePrivateBalanceDecrypt,
    handleOnboardClick,
    onboardError,
  } as const;
}; 