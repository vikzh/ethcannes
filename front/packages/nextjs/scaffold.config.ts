import { NETWORK_CONFIGS, getRpcUrl, getWsUrl } from "./config/network";
import { defineChain } from "viem";
import * as chains from "viem/chains";

export type ScaffoldConfig = {
  targetNetworks: readonly chains.Chain[];
  pollingInterval: number;
  alchemyApiKey: string;
  walletConnectProjectId: string;
  onlyLocalBurnerWallet: boolean;
  rpcOverrides?: Record<number, string>;
};

export const baseSepolia = defineChain({
  id: NETWORK_CONFIGS[84532].CHAIN_ID,
  name: NETWORK_CONFIGS[84532].CHAIN_NAME,
  nativeCurrency: {
    decimals: NETWORK_CONFIGS[84532].CURRENCY.decimals,
    name: NETWORK_CONFIGS[84532].CURRENCY.name,
    symbol: NETWORK_CONFIGS[84532].CURRENCY.symbol,
  },
  rpcUrls: {
    default: {
      http: [getRpcUrl(84532)],
      webSocket: getWsUrl(84532) ? [getWsUrl(84532)!] : undefined,
    },
  },
  blockExplorers: {
    default: {
      name: "BaseScan",
      url: NETWORK_CONFIGS[84532].EXPLORER_URL,
    },
  },
  contracts: {
    multicall3: {
      address: '0xca11bde05977b3631167028862be2a173976ca11',
      blockCreated: 1059647,
    },
  },
});

// Export the default Alchemy API key used as a sentinel value elsewhere in the codebase
export const DEFAULT_ALCHEMY_API_KEY = "demo";

const scaffoldConfig = {
  // The networks on which your DApp is live
  targetNetworks: [baseSepolia],

  // The interval at which your front-end polls the RPC servers for new data
  // Increased for production to reduce load
  pollingInterval: process.env.NEXT_PUBLIC_POLLING_INTERVAL
    ? parseInt(process.env.NEXT_PUBLIC_POLLING_INTERVAL)
    : 30000,

  // This is ours Alchemy's default API key.
  // You can get your own at https://dashboard.alchemyapi.io
  // It's recommended to store it in an env variable:
  // .env.local for local testing, and in the Vercel/system env config for live apps.
  alchemyApiKey: process.env.NEXT_PUBLIC_ALCHEMY_API_KEY || "",

  // This is ours WalletConnect's default project ID.
  // You can get your own at https://cloud.walletconnect.com
  // It's recommended to store it in an env variable:
  // .env.local for local testing, and in the Vercel/system env config for live apps.
  walletConnectProjectId: process.env.NEXT_PUBLIC_WALLET_CONNECT_PROJECT_ID || "3a8170812b534d0ff9d794f19a901d64",

  // Only show the Burner Wallet when running on hardhat network
  onlyLocalBurnerWallet: true,

  // Optional per-chain RPC overrides used by wagmiConfig
  rpcOverrides: {},
} as const satisfies ScaffoldConfig;

export default scaffoldConfig;
