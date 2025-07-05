import { parseAbi } from "viem";

// Contract deployment blocks by chain ID - used for transaction history scanning
export const CONTRACT_DEPLOYMENT_BLOCKS = {
    84532: 0
} as const;

// Proxy service URLs by chain ID
export const PROXY_SERVICE_URLS = {
    84532: "https://proxy.bubble.sodalabs.net"
} as const;

// Factory contract addresses by chain ID
export const FACTORY_ADDRESSES = {
    84532: "0xda8aa6D0C7cB690A1EB54bEfFA537BB7A0deb01c"
} as const;

export const getFactoryAddress = (chainId: number) => {
    return FACTORY_ADDRESSES[chainId as keyof typeof FACTORY_ADDRESSES] || null;
};

export const getContractDeploymentBlock = (chainId: number) => {
    return CONTRACT_DEPLOYMENT_BLOCKS[chainId as keyof typeof CONTRACT_DEPLOYMENT_BLOCKS] || 0;
};

export const getProxyServiceUrl = (chainId: number) => {
    return PROXY_SERVICE_URLS[chainId as keyof typeof PROXY_SERVICE_URLS] || "http://127.0.0.1:5002";
};

export const CONTRACT_DEPLOYMENT_BLOCK = CONTRACT_DEPLOYMENT_BLOCKS[84532];
export const PROXY_SERVICE_URL = PROXY_SERVICE_URLS[84532];

// Factory ABI
export const FACTORY_ABI = [
    {
        "anonymous": false,
        "inputs": [
            {
                "indexed": true,
                "internalType": "address",
                "name": "token",
                "type": "address"
            },
            {
                "indexed": false,
                "internalType": "string",
                "name": "name",
                "type": "string"
            },
            {
                "indexed": false,
                "internalType": "string",
                "name": "symbol",
                "type": "string"
            },
            {
                "indexed": true,
                "internalType": "address",
                "name": "underlying",
                "type": "address"
            },
            {
                "indexed": true,
                "internalType": "address",
                "name": "creator",
                "type": "address"
            }
        ],
        "name": "TokenCreated",
        "type": "event"
    },
    {
        "inputs": [
            {
                "internalType": "string",
                "name": "name",
                "type": "string"
            },
            {
                "internalType": "string",
                "name": "symbol",
                "type": "string"
            },
            {
                "internalType": "address",
                "name": "underlying",
                "type": "address"
            }
        ],
        "name": "createToken",
        "outputs": [
            {
                "internalType": "address",
                "name": "token",
                "type": "address"
            }
        ],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "address",
                "name": "",
                "type": "address"
            }
        ],
        "name": "isTokenFromFactory",
        "outputs": [
            {
                "internalType": "bool",
                "name": "",
                "type": "bool"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "totalTokensCreated",
        "outputs": [
            {
                "internalType": "uint256",
                "name": "",
                "type": "uint256"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    }
] as const;

// Clear token ABI
export const CLEAR_TOKEN_ABI = parseAbi([
    "function name() view returns (string)",
    "function symbol() view returns (string)",
    "function totalSupply() view returns (uint256)",
    "function balanceOf(address) view returns (uint256)",
    "function decimals() view returns (uint8)",
    "function allowance(address owner, address spender) view returns (uint256)",
    "function approve(address spender, uint256 amount) returns (bool)",
    "function transfer(address to, uint256 amount) returns (bool)",
    "function mint(address account, uint256 amount) returns (bool)",
    "event Transfer(address indexed _from, address indexed _to, uint256 _value)",
    "event Approval(address indexed _owner, address indexed _spender, uint256 _value)",
]) as const;

// Private token ABI
export const PRIVATE_TOKEN_ABI = [
    "function name() view returns (string)",
    "function symbol() view returns (string)",
    "function totalSupply() view returns (uint256)",
    "function decimals() view returns (uint8)",
    "function shield(uint256 amount) returns (bool)",
    "function unshield(uint256 amount) returns (bool)",
    "function transfer(address,(uint256 ciphertext, bytes signature))",
    "function balanceOf() returns (bytes)",
    "function balanceOf(address add) view returns (uint256)",
    "event Balance(address indexed _owner, bytes _balance)",
    "event Shield(address indexed from, uint256 amount)",
    "event Unshield(address indexed to, uint256 amount)",
    "event UnshieldRequested(address indexed to, uint256 amount)",
    "event UnshieldFailed(address indexed to, uint256 amount)",
    "event Transfer(address indexed from, address indexed to, uint256 value)",
    "event TransferPrivate(address indexed from, address indexed to)",
    "event ValidateCiphertext(address indexed sender, bool result)",
] as const;
