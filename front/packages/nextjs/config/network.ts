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
        SUBGRAPH_URL: "https://subgraphs.sodalabs.net/subgraphs/name/sodawallet-subgraph-base",
    },
} as const;
