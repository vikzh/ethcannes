// Network configurations for supported chains
// Each network can have:
// - RPC_URL/WS_URL: For blockchain interactions
// - SUBGRAPH_URL: For querying indexed token data
// 
// Environment variables override defaults:
// - NEXT_PUBLIC_BASE_SEPOLIA_SUBGRAPH_URL
export const NETWORK_CONFIGS = {
    // Base Sepolia Network
    84532: {
      RPC_URL: "https://base-sepolia.g.alchemy.com/v2/Wfbjrxwq0HP5XKmKlbmH_WeJ5ZhaMnTH",
      WS_URL: "wss://base-sepolia.g.alchemy.com/v2/Wfbjrxwq0HP5XKmKlbmH_WeJ5ZhaMnTH",
      CHAIN_ID: 84532,
      CHAIN_NAME: "Base Sepolia",
      SHORT_NAME: "Base",
      COLOR: "#0052ff",
      ICON_URL: "https://app.pendle.finance/assets/base-chain-icon-05c4da2d.svg",
      CURRENCY: {
        name: "Ethereum",
        symbol: "ETH",
        decimals: 18,
      },
      EXPLORER_URL: "https://sepolia.basescan.org",
      SUBGRAPH_URL: "https://subgraphs.sodalabs.net/subgraphs/name/mosaic-subgraph-base",
    },
  } as const;
  
  export const NETWORK_CONFIG = NETWORK_CONFIGS[84532];
  
  // Helper function to get network config by chain ID
  export const getNetworkConfig = (chainId: number) => {
    return NETWORK_CONFIGS[chainId as keyof typeof NETWORK_CONFIGS] || NETWORK_CONFIGS[84532];
  };
  
  // Helper function to get RPC URL with environment variable support for any chain
  export const getRpcUrl = (chainId?: number): string => {
    const currentChainId = chainId || 84532; // Default to WorldChain Sepolia
    const networkConfig = getNetworkConfig(currentChainId);
    
   if (currentChainId === 84532) {
      // Base Sepolia specific logic
      if (process.env.NEXT_PUBLIC_BASE_SEPOLIA_RPC_URL) {
        return process.env.NEXT_PUBLIC_BASE_SEPOLIA_RPC_URL;
      }
    } else {
      throw new Error(`Unsupported chain ID: ${currentChainId}`);
    }
    
    // Use the default endpoint for the network
    return networkConfig.RPC_URL;
  };
  
  // Helper function to get WebSocket URL for a chain
  export const getWsUrl = (chainId?: number): string | undefined => {
    const currentChainId = chainId || 84532;
    
    if (currentChainId === 84532) {
      return process.env.NEXT_PUBLIC_BASE_SEPOLIA_WS_URL || NETWORK_CONFIGS[84532].WS_URL;
    } else {
      throw new Error(`Unsupported chain ID: ${currentChainId}`);
    }
  };
  
  // Helper function to get subgraph URL with environment variable support
  export const getSubgraphUrl = (chainId?: number): string => {
    const currentChainId = chainId || 84532; // Default to Base Sepolia (primary subgraph network)
    const networkConfig = getNetworkConfig(currentChainId);
    
    if (currentChainId === 84532) {
      // Base Sepolia specific logic
      if (process.env.NEXT_PUBLIC_BASE_SEPOLIA_SUBGRAPH_URL) {
        return process.env.NEXT_PUBLIC_BASE_SEPOLIA_SUBGRAPH_URL;
      }
      
      // For development, support local subgraph
      if (typeof window !== "undefined" && window.location.hostname === "localhost") {
        return networkConfig.SUBGRAPH_URL || "http://localhost:8000/subgraphs/name/mosaic-subgraph-base";
      }
    }
    
    // Use the default subgraph URL for the network
    return networkConfig.SUBGRAPH_URL || "";
  };
  
  // Helper function to check if subgraph is available for a chain
  export const hasSubgraphSupport = (chainId: number): boolean => {
    const networkConfig = getNetworkConfig(chainId);
    return !!networkConfig.SUBGRAPH_URL || !!getSubgraphUrl(chainId);
  };
  
  // Helper function to get network display info
  export const getNetworkDisplayInfo = (chainId: number) => {
    const config = getNetworkConfig(chainId);
    return {
      name: config.CHAIN_NAME,
      shortName: config.SHORT_NAME,
      color: config.COLOR,
      iconUrl: config.ICON_URL,
    };
  };
  