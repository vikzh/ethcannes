# CLAUDE.md - ETH Cannes Project Context

## Project Overview
Privacy-focused cryptocurrency wallet built on Scaffold-ETH 2 using SodaLabs deployed contracts on Base Sepolia testnet for token shielding operations.

## Key Information for Context Switches

### Project Structure
```
ethcannes/
├── front/                          # Scaffold-ETH 2 frontend
│   ├── packages/
│   │   ├── nextjs/                 # Next.js frontend
│   │   │   ├── contracts/          # Contract configurations
│   │   │   ├── components/         # React components
│   │   │   ├── hooks/              # Custom hooks
│   │   │   ├── pages/              # Next.js pages
│   │   │   └── services/           # API services
│   │   └── hardhat/                # Hardhat development environment
│   └── spec/                       # Project specifications
│       ├── pdr.md                  # Preliminary Design Review
│       └── implementation-plan.md  # Implementation roadmap
└── CLAUDE.md                       # This context file
```

### Core Contracts (SodaLabs)
- **PrivateERC20Factory**: `0x7e58A85165722785AE9CeaDa3D8c2188DCEADDAb`
- **Network**: Base Sepolia (Chain ID: 84532)
- **RPC**: `https://twilight-chaotic-morning.base-sepolia.quiknode.pro/d6d907b0bc59d36bb407d8569350f9e31d4d60af/`
- **Subgraph**: `https://subgraphs.sodalabs.net/subgraphs/name/sodawallet-subgraph-base`
- **Proxy Service**: `https://proxy.bubble.sodalabs.net`

### Key Features
1. **Shield Operation**: Convert clear tokens to private (encrypted)
2. **Unshield Operation**: Convert private tokens back to clear
3. **Private Transfers**: Transfer encrypted token amounts
4. **Balance Decryption**: Decrypt private balances via MPC proxy
5. **Transaction History**: Track all operations via subgraph

## Development Environment

### Essential Commands
```bash
# Start development server
cd front && yarn start

# Install dependencies
cd front && yarn install

# Deploy contracts (if needed)
cd front && yarn deploy --network baseSepolia

# Run tests
cd front && yarn test

# Check contract interactions
cd front && yarn console --network baseSepolia
```

### Network Configuration
- **Chain ID**: 84532 (Base Sepolia)
- **Native Currency**: ETH
- **Block Explorer**: https://sepolia.basescan.org
- **Testnet**: Yes

## Technical Stack

### Frontend
- **Framework**: Next.js 14 with TypeScript
- **UI**: Tailwind CSS, DaisyUI
- **State**: React hooks + Scaffold-ETH 2 hooks
- **Wallet**: RainbowKit
- **Blockchain**: wagmi, viem
- **Animations**: Framer Motion

### Backend Services
- **Smart Contracts**: Already deployed on Base Sepolia
- **Subgraph**: GraphQL API for transaction history
- **MPC Proxy**: Balance decryption service
- **RPC**: QuickNode Base Sepolia endpoint

## Core Operations

### Shield Operation Flow
1. Check clear token allowance
2. Approve spending if needed
3. Call `shield(amount)` on private contract
4. Track transaction progress
5. Update balances

### Unshield Operation Flow
1. Call `unshield(amount)` on private contract
2. Monitor transaction completion
3. Poll for balance changes
4. Update UI with new balances

### Private Transfer Flow
1. Encrypt transfer amount with user key
2. Sign encrypted message
3. Call `transfer(to, encryptedAmount, signature, false)`
4. Track transfer completion

### Balance Management
1. Call `balanceOf()` on private contract
2. Decrypt balance via MPC proxy
3. Display decrypted balance to user
4. Cache for performance

## Important Implementation Details

### Contract Specifics
- **Decimals**: Private tokens use 5 decimals (not 18)
- **MPC Required**: All private operations need MPC proxy
- **Signatures**: Encrypted inputs require valid signatures
- **Events**: Use for tracking operation progress

### Security Considerations
- User encryption keys stored locally
- Always validate signatures before processing
- Use secure RPC endpoints
- Implement input validation

### Error Handling
- Network connection errors
- Transaction failures
- MPC service errors
- Insufficient balance errors
- Invalid signatures

## File Locations

### Key Configuration Files
- `packages/nextjs/contracts/deployedContracts.ts` - Contract addresses & ABIs
- `packages/nextjs/scaffold.config.ts` - Network configuration
- `packages/hardhat/hardhat.config.ts` - Hardhat configuration

### Core Components (To Be Created)
- `packages/nextjs/components/shielding/TokenPairCard.tsx`
- `packages/nextjs/components/shielding/ShieldPanel.tsx`
- `packages/nextjs/components/shielding/OperationProgress.tsx`
- `packages/nextjs/pages/shielding.tsx`

### Essential Hooks (To Be Created)
- `packages/nextjs/hooks/usePrivateTokenFactory.ts`
- `packages/nextjs/hooks/useShieldUnshield.ts`
- `packages/nextjs/hooks/usePrivateBalance.ts`
- `packages/nextjs/hooks/usePrivateTransfer.ts`

## Common Issues & Solutions

### Contract Connection Issues
```bash
# Check network configuration
yarn console --network baseSepolia

# Verify contract addresses
yarn verify --network baseSepolia
```

### Balance Decryption Issues
- Ensure MPC proxy service is accessible
- Check user key availability
- Verify encrypted balance format

### Transaction Failures
- Check gas estimation
- Verify contract approval
- Ensure sufficient balance

## Development Workflow

### Starting Work
1. Review current implementation status in `spec/implementation-plan.md`
2. Check todo list for pending tasks
3. Verify contract connectivity
4. Run development server

### Making Changes
1. Update relevant hooks and components
2. Test contract interactions
3. Verify UI updates
4. Check mobile responsiveness

### Testing
1. Test shield/unshield operations
2. Verify private transfers
3. Check balance decryption
4. Validate error handling

## Project Goals

### Primary Objectives
- Professional shielding interface
- Seamless privacy operations
- Clear progress tracking
- Exceptional user experience
- Mobile-responsive design

### Success Metrics
- Operations complete within 30 seconds
- Clear visual feedback at all steps
- Error rate < 2%
- Mobile-friendly interface
- Intuitive user flows

## Resources

### Documentation
- `spec/pdr.md` - Detailed project requirements
- `spec/implementation-plan.md` - Development roadmap
- `/Users/vlad/src/github.com/vavdoshka/wallet/SMART_CONTRACTS_DOCUMENTATION.md` - Contract specs

### External Services
- Base Sepolia Testnet: https://sepolia.basescan.org
- SodaLabs Subgraph: https://subgraphs.sodalabs.net
- MPC Proxy: https://proxy.bubble.sodalabs.net

---

**Remember**: This is a privacy-focused wallet using encrypted balances and MPC for cryptographic operations. Always consider security and user privacy in implementation decisions.