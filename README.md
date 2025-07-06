# Mosaic — Fast, Private Transactions on Public Blockchains

## Overview
Mosaic enables **near-instant, end-to-end-encrypted transfers and DeFi interactions** on public Ethereum-compatible chains.  
Using a [garbled–circuits-based](https://www.sodalabs.xyz/lack-of-privacy-sidelines-institutions-from-web3/) **multi-party computation (MPC) network** developed by **[Soda Labs](https://www.sodalabs.xyz/)**, Mosaic wraps any ERC-20 token in a *shielded* version that keeps amounts and user data private while preserving on-chain auditability.

Key use-cases include:
- Private payments & payroll
- Confidential DeFi trading (DEX, lending, derivatives)
- On-chain KYC / compliance checks without revealing user data
- Institutional settlement rails that meet TradFi privacy requirements

👉 **Live demo:** [https://mosaic-mu-two.vercel.app/](https://mosaic-mu-two.vercel.app/)

## Why Garbled Circuits ?
Garbled circuits let multiple parties jointly evaluate an arbitrary computation on **encrypted inputs** where *no participant ever sees the raw data*.  
Compared to approaches like Fully Homomorphic Encryption (FHE) they are:
- 💨 **Faster** — shield / unshield completes in seconds rather than minutes.
- 🧩 **General-purpose** — any Solidity function can be emulated privately.
- 🛰 **Composable** — easily integrates with existing DeFi protocols.

## High-Level Architecture
```
User ↔ Frontend (NextJS + Wagmi) ↔ Public Chain (Base Sepolia)
                                         ↘
                                          Shielded Token
                                            ↕
                                      MPC Network (Garbled Circuits)
```
1. A user *shields* an ERC-20 → receives its private counterpart.  
2. Private transfers / computations happen inside the MPC network; only commitments are published.  
3. When *unshielding*, the MPC proves correctness and releases the underlying ERC-20 on-chain.

State is split between:
- **Public layer** – ERC-20 wrappers + commitments (decentralisation & auditability).
- **Private layer** – MPC nodes holding encrypted state (privacy & compliance).

## Repository Layout
```
contracts/eth/          Solidity smart contracts (ShieldedToken, Factory, MPC interfaces)
front/packages/hardhat  Hardhat config, deployment scripts, tests
front/packages/nextjs   NextJS dApp built on Scaffold-ETH 2
subgraph-base-sepolia/  The Graph subgraph for shielded token events
```

## Tech Stack
- **Smart contracts** – Solidity, Hardhat, Foundry
- **Frontend** – NextJS (App Router), Scaffold-ETH 2, RainbowKit, Wagmi, Viem, Tailwind CSS
- **Privacy layer** – Garbled circuits MPC (Soda Labs)
- **Indexing** – The Graph (Base Sepolia)
- **Crypto primitives** – Hybrid RSA & AES encryption between clients ↔ MPC
- **CI / CD** – Vercel (frontend), Hardhat deploy scripts (contracts)

## Quick Start
```bash
# Install deps (root of repo)
yarn install

# Start local dev chain (Hardhat)
yarn chain

# Deploy contracts to local chain
yarn deploy

# Run the dApp frontend (http://localhost:3000)
yarn start
```
Additional commands:
- `yarn hardhat:test` – run Solidity tests
- `yarn graph:codegen && yarn graph:deploy` – update / deploy subgraph

## Contributing
1. Fork & clone the repo  
2. Create a feature branch `git checkout -b feat/<name>`  
3. Commit your changes (`yarn lint` passes)  
4. Open a PR against `main`

Please read `CONTRIBUTING.md` for full guidelines.

## License
This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.
