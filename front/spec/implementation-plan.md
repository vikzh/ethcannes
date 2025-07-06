# ETH Cannes Implementation Plan

## Project Overview
Privacy-focused cryptocurrency wallet built on Scaffold-ETH 2 using SodaLabs deployed contracts on Base Sepolia testnet.

## Deployed Contracts Integration

### Key Contracts
- **PrivateERC20Factory**: `0x7e58A85165722785AE9CeaDa3D8c2188DCEADDAb` (Base Sepolia)
- **Network**: Base Sepolia (Chain ID: 84532)
- **RPC**: `https://twilight-chaotic-morning.base-sepolia.quiknode.pro/d6d907b0bc59d36bb407d8569350f9e31d4d60af/`
- **Subgraph**: `https://subgraphs.sodalabs.net/subgraphs/name/sodawallet-subgraph-base`
- **Proxy Service**: `https://proxy.bubble.sodalabs.net`

## Phase 1: Contract Integration (Week 1)

### Day 1: Contract Setup
- [ ] Update `deployedContracts.ts`
- [ ] Configure Base Sepolia network in hardhat_bkp.config.ts
- [ ] Add contract ABIs to project
- [ ] Test factory connection

**Files to update:**
```typescript
// packages/nextjs/contracts/deployedContracts.ts
const deployedContracts = {
  84532: {
    PrivateERC20Factory: {
      address: "0x7e58A85165722785AE9CeaDa3D8c2188DCEADDAb",
      abi: [/* Factory ABI */]
    }
  }
} as const;
```

### Day 2: Network Configuration
- [ ] Add Base Sepolia to scaffold.config.ts
- [ ] Configure RPC endpoint
- [ ] Set up subgraph connection
- [ ] Test network connectivity

**Network Config:**
```typescript
// packages/nextjs/scaffold.config.ts
const scaffoldConfig = {
  targetNetworks: [
    {
      id: 84532,
      name: "Base Sepolia",
      nativeCurrency: { name: "ETH", symbol: "ETH", decimals: 18 },
      rpcUrls: {
        default: { 
          http: ["https://twilight-chaotic-morning.base-sepolia.quiknode.pro/d6d907b0bc59d36bb407d8569350f9e31d4d60af/"] 
        }
      },
      blockExplorers: {
        default: { name: "BaseScan", url: "https://sepolia.basescan.org" }
      }
    }
  ]
};
```

### Day 3: Core Hooks Implementation
- [ ] Create `usePrivateTokenFactory` hook
- [ ] Implement `usePrivateBalance` hook
- [ ] Add `useShieldUnshield` hook
- [ ] Create `usePrivateTransfer` hook

**Key Hooks:**
```typescript
// usePrivateTokenFactory.ts
export const usePrivateTokenFactory = () => {
  const { data: factory } = useScaffoldContractRead({
    contractName: "PrivateERC20Factory",
    functionName: "totalTokensCreated",
  });
  
  const { writeAsync: createToken } = useScaffoldContractWrite({
    contractName: "PrivateERC20Factory",
    functionName: "createToken",
  });
  
  return { factory, createToken };
};
```

### Day 4: Token Operations
- [ ] Implement shield operation with approval flow
- [ ] Add unshield operation
- [ ] Create balance decryption logic
- [ ] Add MPC proxy integration

**Shield Operation:**
```typescript
// Shield flow: approve → shield
const { writeAsync: approve } = useScaffoldContractWrite({
  contractName: "ClearToken",
  functionName: "approve",
  args: [privateTokenAddress, amount],
});

const { writeAsync: shield } = useScaffoldContractWrite({
  contractName: "PrivateERC20", 
  functionName: "shield",
  args: [amount],
});
```

### Day 5: UI Components
- [ ] Create `TokenPairCard` component
- [ ] Implement `ShieldPanel` component
- [ ] Add `BalanceDisplay` with decrypt functionality
- [ ] Create `OperationProgress` component

### Day 6: Private Transfer Implementation
- [ ] Implement encrypted transfer preparation
- [ ] Add signature creation flow
- [ ] Create recipient address validation
- [ ] Add transfer confirmation UI

### Day 7: Testing & Validation
- [ ] Test all contract interactions
- [ ] Validate shield/unshield flows
- [ ] Test private transfers
- [ ] Verify balance decryption

## Phase 2: Core Features (Week 2)

### Day 8: Main Shielding Interface
- [ ] Create main shielding page
- [ ] Integrate token pair display
- [ ] Add operation selection (Shield/Unshield/Transfer)
- [ ] Implement responsive design

### Day 9: Progress Tracking
- [ ] Add multi-step progress bars
- [ ] Implement operation status tracking
- [ ] Create loading states for each step
- [ ] Add error handling with retry

### Day 10: Balance Management
- [ ] Implement real-time balance updates
- [ ] Add balance refresh functionality
- [ ] Create balance decryption UI
- [ ] Add balance history tracking

### Day 11: Transaction History
- [ ] Connect to SodaLabs subgraph
- [ ] Implement transaction list component
- [ ] Add transaction filtering
- [ ] Create transaction detail view

### Day 12: Error Handling
- [ ] Add comprehensive error messages
- [ ] Implement retry mechanisms
- [ ] Create error state components
- [ ] Add error logging

### Day 13: MPC Integration
- [ ] Implement MPC proxy connection
- [ ] Add user key management
- [ ] Create balance decryption flow
- [ ] Add MPC error handling

### Day 14: Week 2 Testing
- [ ] End-to-end operation testing
- [ ] Performance optimization
- [ ] Mobile responsiveness
- [ ] Cross-browser testing

## Phase 3: Advanced Features (Week 3)

### Day 15: Token Creation
- [ ] Implement token creation using factory
- [ ] Add token metadata input
- [ ] Create token creation confirmation
- [ ] Add created token management

### Day 16: Advanced Transfers
- [ ] Implement encrypted transfer UI
- [ ] Add recipient validation
- [ ] Create transfer amount encryption
- [ ] Add transfer confirmation flow

### Day 17: Subgraph Integration
- [ ] Connect to SodaLabs subgraph
- [ ] Implement GraphQL queries
- [ ] Add data caching
- [ ] Create data refresh mechanisms

### Day 18: User Experience Polish
- [ ] Add loading animations
- [ ] Implement progress indicators
- [ ] Create success/error states
- [ ] Add keyboard shortcuts

### Day 19: Mobile Optimization
- [ ] Optimize for mobile devices
- [ ] Add touch gestures
- [ ] Improve mobile navigation
- [ ] Test on various screen sizes

### Day 20: Security Enhancements
- [ ] Add input validation
- [ ] Implement rate limiting
- [ ] Add security warnings
- [ ] Create security documentation

### Day 21: Week 3 Review
- [ ] Comprehensive testing
- [ ] Performance benchmarking
- [ ] Security review
- [ ] Documentation updates

## Phase 4: Final Polish (Week 4)

### Day 22-28: Final Implementation
- [ ] Complete feature implementation
- [ ] Add comprehensive testing
- [ ] Optimize performance
- [ ] Create documentation
- [ ] Prepare for deployment

## Key Technical Details

### Contract Interactions

#### Shield Operation
```typescript
// 1. Check allowance
const allowance = await clearContract.allowance(userAddress, privateTokenAddress);

// 2. Approve if needed
if (allowance < amount) {
  await clearContract.approve(privateTokenAddress, amount);
}

// 3. Shield tokens
await privateContract.shield(amount);
```

#### Unshield Operation
```typescript
// 1. Call unshield
const tx = await privateContract.unshield(amount);
await tx.wait();

// 2. Poll for balance changes
const newBalance = await pollForBalanceChange(clearContract, userAddress);
```

#### Private Transfer
```typescript
// 1. Encrypt amount
const { encryptedInt, message } = prepareMessage(amount, userAddress, userKey);

// 2. Sign message
const signature = await signer.signMessage(ethers.getBytes(message));

// 3. Transfer
await contract.transfer(recipient, encryptedInt, signature, false);
```

#### Balance Decryption
```typescript
// 1. Get encrypted balance
const encryptedBalance = await privateContract.balanceOf();

// 2. Decrypt via proxy
const decryptedBalance = await decryptBalanceViaProxy(encryptedBalance, userKey);
```

### Essential Configuration

#### Network Setup
- **Chain ID**: 84532 (Base Sepolia)
- **RPC**: Use provided QuickNode endpoint
- **Subgraph**: Connect to SodaLabs subgraph
- **Proxy**: Use SodaLabs proxy service

#### Contract Addresses
- **Factory**: `0x7e58A85165722785AE9CeaDa3D8c2188DCEADDAb`
- **Multicall3**: `0xca11bde05977b3631167028862be2a173976ca11`

### Important Notes

1. **5 Decimal Precision**: Private tokens use 5 decimals (not 18)
2. **MPC Required**: Private operations require MPC proxy
3. **Signature Validation**: All encrypted inputs need signatures
4. **Subgraph Indexing**: Use subgraph for transaction history
5. **Proxy Service**: Required for balance decryption

### Success Criteria

- [ ] Shield/unshield operations work seamlessly
- [ ] Private transfers function correctly
- [ ] Balance decryption works via proxy
- [ ] Transaction history loads from subgraph
- [ ] Mobile-responsive design
- [ ] Professional UI/UX
- [ ] Error handling and recovery

### Development Commands

```bash
# Start development
yarn start

# Connect to Base Sepolia
yarn chain --network baseSepolia

# Deploy (if needed)
yarn deploy --network baseSepolia

# Test contracts
yarn test
```

---

**Next Steps:**
1. Configure Base Sepolia network
2. Update contract addresses
3. Implement core hooks
4. Create UI components
5. Test contract interactions