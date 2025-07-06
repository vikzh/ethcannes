# Mosaic: Private Transactions on Public Blockchains

Mosaic enables fast, private transactions on public blockchains using garbled circuits-based multi-party computation (MPC). Transaction amounts and user data remain encrypted end-to-end, while shield/unshield operations happen almost instantly, far faster than alternatives like FHE.

The system runs on an MPC network where no node ever sees raw data. Garbled circuits allow secure, general-purpose computation on encrypted inputs, enabling privacy-preserving operations like private payments, confidential DeFi trades, KYC checks, and more. State is distributed across public and private layers to combine decentralization, auditability, and performance.

This project directly addresses one of the biggest blockers to institutional adoption of Web3: privacy. It bridges the trustless, permissionless nature of DeFi with the compliance requirements of TradFi — enabling secure, scalable, and compliant private transactions on public infrastructure.

**Product Link**: https://mosaic-git-main-viktanmail-gmailcoms-projects.vercel.app/

## Project Overview

This repository contains the smart contracts infrastructure for Mosaic, built using the Hardhat framework. It includes:

- Smart contracts for shielded tokens and private order books
- Multi-party computation (MPC) integration contracts
- TypeScript integration tests using `mocha` and ethers.js
- Deployment scripts and modules for various networks
- Token factory contracts for creating privacy-enabled assets

## Project Structure

The main components of this project are:

- `contracts/` - Core smart contracts including ShieldedToken, PrivateOrderBook, and MPC integration
- `test/` - Comprehensive test suite for contract functionality
- `ignition/modules/` - Deployment modules for contract deployment
- `typechain-types/` - Generated TypeScript types for contract interaction

## Key Contracts

- **ShieldedToken**: Privacy-preserving token implementation
- **ShieldedTokenFactory**: Factory for deploying shielded tokens
- **PrivateOrderBook**: Private trading functionality
- **MPC Integration**: Contracts for multi-party computation operations

## Usage

### Running Tests

To run all tests in the project:

```shell
npx hardhat test
```

### Contract Deployment

Deploy the ShieldedTokenFactory to a local chain:

```shell
npx hardhat ignition deploy ignition/modules/ShieldTokenFactory.ts
```

Deploy a test clear token:

```shell
npx hardhat ignition deploy ignition/modules/TestClearToken.ts
```

### Network Deployment

To deploy to a testnet, you need an account with funds. The Hardhat configuration supports various networks including Sepolia Base.

Set your private key using environment variables or the hardhat-keystore plugin:

```shell
npx hardhat keystore set SEPOLIA_PRIVATE_KEY
```

Deploy to Sepolia Base:

```shell
npx hardhat ignition deploy --network sepolia-base ignition/modules/ShieldTokenFactory.ts
```

## Development

This project uses Hardhat 3 for development and testing. The configuration includes:

- TypeScript support
- Ethers.js integration
- Comprehensive testing framework
- Multi-network deployment support

---

Mosaic represents the next generation of privacy-preserving blockchain infrastructure, enabling institutional-grade privacy while maintaining the benefits of public, decentralized networks.
