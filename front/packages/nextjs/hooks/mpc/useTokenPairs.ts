import { useState, useEffect } from "react";
import { ethers } from "ethers";
import { getTokenPairs } from "../../config/contracts";
import { BlockchainService, SubgraphToken } from "../../services/wallet/blockchainService";
import { NetworkTokenData, SUPPORTED_NETWORKS } from "./useMultiNetworkTokenData";
import { CLEAR_TOKEN_ABI } from "../../config/contracts";
import { getRpcUrl } from "../../config/network";

export interface TokenPair {
  chainId: number;
  clearAddress: string;
  privateAddress: string;
  name: string;
  symbol: string;
  data: NetworkTokenData;
  // Individual token balances (separate from network data)
  clearTokenBalance?: string;
  privateTokenBalance?: string;
}

export const useTokenPairs = (
  networkTokenData: Record<number, NetworkTokenData>,
  activeNetworks: Set<number>,
  userAddress?: string
) => {
  const [filteredTokenPairs, setFilteredTokenPairs] = useState<TokenPair[]>([]);

  // Function to update a specific token pair's balance
  const updateTokenPairBalance = (privateAddress: string, updates: { clearTokenBalance?: string; privateTokenBalance?: string }) => {
    setFilteredTokenPairs(prev => 
      prev.map(pair => 
        pair.privateAddress === privateAddress 
          ? { ...pair, ...updates }
          : pair
      )
    );
  };

  // Fetch individual token balance for a specific contract
  const fetchTokenBalance = async (tokenAddress: string, userAddress: string, networkId: number): Promise<string> => {
    try {
      const provider = new ethers.JsonRpcProvider(getRpcUrl(networkId));
      const contract = new ethers.Contract(tokenAddress, CLEAR_TOKEN_ABI, provider);
      const balance = await contract.balanceOf(userAddress);
      return balance.toString();
    } catch (error) {
      console.error(`Error fetching balance for token ${tokenAddress}:`, error);
      return "0";
    }
  };

  // Fetch underlying token metadata from chain
  const fetchUnderlyingTokenMetadata = async (tokenAddress: string, networkId: number) => {
    try {
      const provider = new ethers.JsonRpcProvider(getRpcUrl(networkId));
      const contract = new ethers.Contract(tokenAddress, CLEAR_TOKEN_ABI, provider);
      
      const [name, symbol, decimals] = await Promise.all([
        contract.name(),
        contract.symbol(),
        contract.decimals()
      ]);
      
      return {
        name: name as string,
        symbol: symbol as string,
        decimals: Number(decimals)
      };
    } catch (error) {
      console.error(`Error fetching metadata for token ${tokenAddress}:`, error);
      return {
        name: "Unknown Token",
        symbol: "UNK",
        decimals: 18
      };
    }
  };

  // Get filtered token pairs from all networks (uses subgraph data only)
  const getFilteredTokenPairs = async (): Promise<TokenPair[]> => {
    const allPairs: TokenPair[] = [];

    for (const networkId of SUPPORTED_NETWORKS) {
      if (!activeNetworks.has(networkId)) continue;

      const data = networkTokenData[networkId];
      if (!data?.contractsDeployed) continue;

      // All networks now use subgraph data
      try {
        const subgraphTokens = await BlockchainService.fetchTokensFromSubgraph(networkId);

        if (subgraphTokens.length > 0) {
          // Create pairs with comprehensive metadata
          for (const token of subgraphTokens) {
            // Fetch underlying token metadata from chain
            const underlyingMetadata = await fetchUnderlyingTokenMetadata(token.underlying, networkId);

            // Fetch balance from underlying token contract
            const clearTokenBalance = userAddress 
              ? await fetchTokenBalance(token.underlying, userAddress, networkId)
              : "0";

            // Determine USD base rate for known tokens (simple hard-coded map for now)
            const upperSym = underlyingMetadata.symbol.toUpperCase();
            let baseRate = 1; // default for stablecoins like USDC
            if (upperSym.includes("WETH") || upperSym === "ETH" || upperSym === "WETH") {
              baseRate = 2130;
            }

            // Create comprehensive token data combining subgraph and on-chain data
            const tokenSpecificData = {
              ...data,
              // Clear token = underlying token (actual on-chain metadata)
              clearTokenName: underlyingMetadata.name,
              clearTokenSymbol: underlyingMetadata.symbol,
              clearTokenDecimals: underlyingMetadata.decimals,
              // Private token = custom wrapper (subgraph metadata)
              privateTokenName: token.name, // Use actual token name from subgraph
              privateTokenSymbol: token.symbol, // Use actual token symbol from subgraph
              privateTokenDecimals: 5, // mpc limitation
              baseRate,
            };

            const finalPair = {
              chainId: networkId,
              clearAddress: token.underlying, // underlying token contract
              privateAddress: token.id, // private token wrapper contract
              name: `${token.name} (${underlyingMetadata.symbol})`, // e.g., "Query Test Token (sbtUSDC)"
              symbol: `${token.symbol}/${underlyingMetadata.symbol}`, // e.g., "QTT/sbtUSDC"
              data: tokenSpecificData,
              clearTokenBalance,
              privateTokenBalance: undefined, // Will be decrypted individually
            };
            
            allPairs.push(finalPair);
          }
        }
      } catch (error) {
        // No fallback - if subgraph fails, no tokens are available
      }
    }

    return allPairs;
  };

  useEffect(() => {
    const fetchTokenPairs = async () => {
      const pairs = await getFilteredTokenPairs();
      setFilteredTokenPairs(pairs);
    };

    if (Object.keys(networkTokenData).length > 0) {
      fetchTokenPairs();
    }
  }, [networkTokenData, activeNetworks]);

  return {
    filteredTokenPairs,
    getFilteredTokenPairs,
    updateTokenPairBalance,
  };
}; 