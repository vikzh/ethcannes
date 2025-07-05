import {HardhatUserConfig} from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import dotenv from "dotenv";

dotenv.config();

const config: HardhatUserConfig = {
    solidity: {
        version: "0.8.24",
        settings: {
            optimizer: {
                enabled: true,
                runs: 8
            },
            evmVersion: "cancun",
            viaIR: true
        }
    },
    networks: {
        "sepolia-base": {
            chainId: 84532,
            url: "https://base-sepolia.g.alchemy.com/v2/Wfbjrxwq0HP5XKmKlbmH_WeJ5ZhaMnTH",
            accounts: {
                mnemonic: process.env.MNEMONIC || ""
            },
            gas: "auto",
            gasPrice: "auto",
            gasMultiplier: 1.2
        },
    }
};

export default config;
