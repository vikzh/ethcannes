import { useState, useEffect } from "react";
import { ethers } from "ethers";
import { CLEAR_TOKEN_ABI, PRIVATE_TOKEN_ABI, getContractAddresses } from "../../config/contracts";
import { getRpcUrl, hasSubgraphSupport } from "../../config/network";

// Supported networks for multi-chain display (networks with subgraph support)
export const SUPPORTED_NETWORKS = [84532]; // Base Sepolia (primary subgraph network)

// Interface for multi-network token data
export interface NetworkTokenData {
  chainId: number;
  clearTokenName: string | null;
  clearTokenSymbol: string | null;
  clearTokenDecimals: number | null;
  clearTokenBalance: string | null;
  privateTokenName: string | null;
  privateTokenSymbol: string | null;
  privateTokenDecimals: number | null;
  privateTokenBalance: string | null;
  contractsDeployed: boolean;
  isConnectedNetwork: boolean;
}

export const useMultiNetworkTokenData = (address: string | undefined, chainId: number) => {
  const [networkTokenData, setNetworkTokenData] = useState<Record<number, NetworkTokenData>>({});
  const [isLoading, setIsLoading] = useState(true);

  const updateNetworkData = (networkId: number, updates: Partial<NetworkTokenData>) => {
    setNetworkTokenData(prev => ({
      ...prev,
      [networkId]: {
        ...prev[networkId],
        ...updates,
      },
    }));
  };

  useEffect(() => {
    const fetchNetworkData = async () => {
      setIsLoading(true);
      const newNetworkData: Record<number, NetworkTokenData> = {};

      for (const networkId of SUPPORTED_NETWORKS) {
        const isConnected = networkId === chainId;

        const data: NetworkTokenData = {
          chainId: networkId,
          clearTokenName: null,
          clearTokenSymbol: null,
          clearTokenDecimals: null,
          clearTokenBalance: null,
          privateTokenName: null,
          privateTokenSymbol: null,
          privateTokenDecimals: null,
          privateTokenBalance: null,
          contractsDeployed: true, // Assume contracts are deployed if network is in SUPPORTED_NETWORKS
          isConnectedNetwork: isConnected,
        };

        // Note: Specific contract metadata and balances are now fetched 
        // individually by useTokenPairs from subgraph data
        newNetworkData[networkId] = data;
      }

      setNetworkTokenData(newNetworkData);
      setIsLoading(false);
    };

    fetchNetworkData();
  }, [address, chainId]);

  return {
    networkTokenData,
    setNetworkTokenData,
    updateNetworkData,
    isLoading,
    SUPPORTED_NETWORKS,
  };
}; 