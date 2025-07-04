# ETH Cannes Project - Enhanced Preliminary Design Review (PDR)

## Document Information

| Field | Value |
|-------|-------|
| **Document Type** | Enhanced Preliminary Design Review (PDR) |
| **Project Name** | ETH Cannes Privacy - Shielding Interface |
| **Version** | 2.0 |
| **Platform** | Scaffold-ETH 2 |
| **Primary Focus** | Token Shielding Operations |
| **Review Status** | Final Draft |

## Executive Summary

The ETH Cannes project is a privacy-focused cryptocurrency wallet built on Scaffold-ETH 2, designed to provide an intuitive and professional interface for token shielding operations on Base Sepolia testnet. The wallet's primary feature is the shielding screen, which enables users to seamlessly convert between clear (public) and private (encrypted) tokens while maintaining a lucrative user experience with clear progress tracking.

### Key Objectives
- **Primary Focus**: Deliver exceptional shielding/unshielding user experience
- **User Experience**: Professional interface with clear progress indicators
- **Technical Excellence**: Leverage Scaffold-ETH 2's built-in capabilities
- **Privacy First**: Seamless management of encrypted token operations
- **Error Clarity**: Comprehensive error handling with actionable feedback

### Success Criteria
- Shielding operations complete within 30 seconds with clear progress tracking
- Private token balances display correctly (masked/decrypted states)
- Transfer operations for shielded assets work seamlessly
- Transaction history provides complete audit trail
- Professional UI with smooth animations and loading states
- Zero confusion during any operation - crystal clear UX

## System Architecture

### High-Level Architecture (Scaffold-ETH 2 Based)

```
┌─────────────────────────────────────────────────────────────────┐
│                    Scaffold-ETH 2 Application                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌──────────────┐  ┌─────────────────┐  ┌──────────────────┐   │
│  │   Next.js    │  │  Hardhat Local  │  │   RainbowKit    │   │
│  │   Frontend   │  │    Network      │  │  Wallet Connect │   │
│  └──────┬───────┘  └────────┬────────┘  └────────┬─────────┘   │
│         │                    │                     │             │
│  ┌──────▼───────────────────▼─────────────────────▼─────────┐   │
│  │                    Core Components                        │   │
│  ├───────────────────────────────────────────────────────────┤   │
│  │  • ShieldingScreen (Primary Interface)                   │   │
│  │  • TokenPairCard (Clear/Private Display)                 │   │
│  │  • ActionPanels (Shield/Unshield/Transfer)              │   │
│  │  • TransactionHistory                                    │   │
│  │  • ProgressTrackers (Visual Operation Feedback)          │   │
│  └───────────────────────────────────────────────────────────┘   │
│                                                                   │
│  ┌───────────────────────────────────────────────────────────┐   │
│  │                    Service Layer                          │   │
│  ├───────────────────────────────────────────────────────────┤   │
│  │  • useScaffoldContractRead/Write (Contract Interactions) │   │
│  │  • usePrivateBalance (Balance Decryption)               │   │
│  │  • useTransactionHistory (Subgraph Queries)             │   │
│  │  • useMPCOperations (Privacy Operations)                │   │
│  └───────────────────────────────────────────────────────────┘   │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│                    External Services                             │
├─────────────────────────────────────────────────────────────────┤
│  • Base Sepolia RPC                                             │
│  • MPC Proxy Service (Balance Decryption)                       │
│  • Subgraph Indexer (Transaction History)                       │
│  • IPFS (Metadata Storage)                                      │
└─────────────────────────────────────────────────────────────────┘
```

### Technology Stack
- **Framework**: Scaffold-ETH 2 (Next.js 14, TypeScript, Hardhat)
- **UI Components**: Tailwind CSS, DaisyUI, Custom Design System
- **Wallet Integration**: RainbowKit (Scaffold-ETH 2 default)
- **Smart Contract Interaction**: wagmi hooks, viem
- **State Management**: React hooks, Scaffold-ETH 2 custom hooks
- **Data Fetching**: GraphQL (Subgraph), Scaffold-ETH 2 hooks
- **Animation**: Framer Motion for professional transitions

## Functional Requirements

### FR-001: Shielding Screen (Primary Feature)
**Priority**: Critical  
**Description**: The main interface for all shielding operations with lucrative UX

**Visual Design Requirements**:
```
┌─────────────────────────────────────────────────────────────┐
│                    Shielding Interface                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌─────────────────┐        ┌─────────────────┐            │
│  │   Clear Token    │   ➜    │  Private Token  │            │
│  │                 │        │                 │            │
│  │  Balance: 1,000 │        │  Balance: *****  │            │
│  │     USDC        │        │  [Decrypt]      │            │
│  └─────────────────┘        └─────────────────┘            │
│                                                              │
│  ┌─────────────────────────────────────────────┐            │
│  │           Active Operation Panel             │            │
│  │                                              │            │
│  │  Operation: [Shield] [Unshield] [Transfer]  │            │
│  │                                              │            │
│  │  Amount: [_______________] MAX               │            │
│  │                                              │            │
│  │  [────────────────────] 75% Complete        │            │
│  │  Status: Confirming transaction...           │            │
│  │                                              │            │
│  │         [Execute Operation]                  │            │
│  └─────────────────────────────────────────────┘            │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**Key Features**:
- **Token Pair Display**: Side-by-side clear and private token cards
- **Visual Flow Indicators**: Animated arrows showing token flow direction
- **Progress Tracking**: Multi-step progress bars with status messages
- **Quick Actions**: One-click MAX button, balance refresh
- **Operation Panels**: Contextual forms for each operation type

**Animation Requirements**:
- Token flow animations during operations
- Smooth panel transitions when switching operations
- Loading shimmer effects during data fetching
- Success/error state animations
- Progress bar animations with percentage display

**Acceptance Criteria**:
- All operations accessible within 2 clicks
- Progress visible at every step of operation
- Clear visual feedback for all states
- Mobile-responsive design
- Accessibility compliant (WCAG 2.1 AA)

### FR-002: Shield Operation
**Priority**: Critical  
**Description**: Convert clear tokens to private tokens

**User Flow**:
1. User selects "Shield" operation
2. Enter amount (with MAX option)
3. Review gas estimate
4. Approve token spending (if needed)
5. Confirm shielding transaction
6. Track progress with visual indicators
7. View success confirmation

**Progress Tracking Stages**:
```
[Approval Check] → [Token Approval] → [Shielding] → [Confirming] → [Complete]
      10%              30%               60%           90%           100%
```

**Technical Implementation**:
```typescript
const { writeAsync: approveToken } = useScaffoldContractWrite({
  contractName: "ClearToken",
  functionName: "approve",
  args: [privateTokenAddress, amount],
});

const { writeAsync: shieldTokens } = useScaffoldContractWrite({
  contractName: "PrivateToken",
  functionName: "shield",
  args: [amount],
  onBlockConfirmation: (txnReceipt) => {
    // Update UI with success state
  },
});
```

### FR-003: Unshield Operation
**Priority**: Critical  
**Description**: Convert private tokens back to clear tokens

**User Flow**:
1. Decrypt private balance (if not already decrypted)
2. Select "Unshield" operation
3. Enter amount to unshield
4. Confirm MPC operation
5. Track multi-step progress
6. View updated balances

**MPC Integration**:
- Automatic user onboarding if not registered
- Balance decryption with loading states
- Clear error messages for MPC failures

### FR-004: Private Token Transfer
**Priority**: High  
**Description**: Transfer shielded assets between addresses

**User Flow**:
1. Select "Transfer" operation
2. Enter recipient address
3. Enter transfer amount
4. Sign encrypted transfer
5. Track transaction progress
6. View in transaction history

**Features**:
- Address validation with ENS support
- Recent addresses dropdown
- QR code scanning (optional)
- Transfer confirmation modal

### FR-005: Transaction History
**Priority**: High  
**Description**: Comprehensive history of all operations

**Display Requirements**:
- Grouped by operation type
- Decryptable private amounts
- Block explorer links
- Status indicators
- Search and filter capabilities

**Visual Design**:
```
┌─────────────────────────────────────────────────┐
│  Transaction History                             │
├─────────────────────────────────────────────────┤
│  🔍 Search: [_______________] Filter: [All ▼]   │
├─────────────────────────────────────────────────┤
│  Today                                           │
│  ├─ 🛡️ Shielded 100 USDC           ✓ Complete  │
│  └─ 📤 Transfer to 0x123...         ✓ Complete  │
│                                                  │
│  Yesterday                                       │
│  ├─ 🔓 Unshielded 50 USDC          ✓ Complete  │
│  └─ 🛡️ Shielded 200 USDC           ✓ Complete  │
└─────────────────────────────────────────────────┘
```

### FR-006: Balance Management
**Priority**: High  
**Description**: Display and manage token balances

**Requirements**:
- Real-time balance updates
- Private balance decryption on demand
- Loading states during updates
- Error handling for failed updates
- Manual refresh capability

## Non-Functional Requirements

### NFR-001: Professional UI/UX
**Description**: Deliver a polished, professional interface

**Requirements**:
- **Loading States**: Skeleton screens, spinners, progress bars
- **Error Messages**: Clear, actionable error messages with recovery options
- **Animations**: Smooth, purposeful animations (not excessive)
- **Feedback**: Immediate visual feedback for all interactions
- **Consistency**: Unified design language throughout

**Implementation**:
```typescript
// Example: Professional loading state
const TokenBalance = () => {
  const { data, isLoading, error } = useScaffoldContractRead({
    contractName: "PrivateToken",
    functionName: "balanceOf",
  });

  if (isLoading) {
    return <BalanceSkeleton />; // Shimmer effect
  }

  if (error) {
    return <ErrorState message="Failed to load balance" retry={refetch} />;
  }

  return <AnimatedBalance value={data} />;
};
```

### NFR-002: Performance
**Description**: Ensure responsive, fast user experience

**Requirements**:
- Initial page load < 2 seconds
- Operation initiation < 500ms
- Balance updates < 3 seconds
- Smooth 60fps animations
- Optimistic UI updates where appropriate

### NFR-003: Error Handling
**Description**: Comprehensive error management

**Error Categories**:
1. **Network Errors**: Clear network status indicators
2. **Transaction Errors**: Detailed failure reasons
3. **MPC Errors**: User-friendly MPC error messages
4. **Validation Errors**: Inline form validation

**Example Error States**:
```typescript
// User-friendly error messages
const ERROR_MESSAGES = {
  INSUFFICIENT_BALANCE: "You don't have enough tokens to complete this operation",
  NETWORK_ERROR: "Connection lost. Please check your network",
  MPC_ONBOARDING_REQUIRED: "Please complete the privacy setup to continue",
  TRANSACTION_FAILED: "Transaction failed. Click here to retry",
};
```

### NFR-004: Security
**Description**: Maintain high security standards

**Requirements**:
- Secure key storage (browser localStorage)
- Input validation and sanitization
- Clear security warnings
- No sensitive data in URLs
- HTTPS-only communication

## Design System Integration

### Visual Design Principles

#### Color Palette (Extended from Base Design System)
```css
/* Shielding Operation Colors */
--color-shield-gradient-start: #3B82F6;
--color-shield-gradient-end: #6B7280;
--color-operation-active: #3B82F6;
--color-operation-hover: #2563EB;

/* Status Colors */
--color-progress-bar: #3B82F6;
--color-progress-complete: #22C55E;
--color-progress-track: #E5E7EB;

/* Animation Timing */
--animation-fast: 200ms;
--animation-normal: 300ms;
--animation-slow: 500ms;
```

#### Component Styling

**Token Cards**:
```css
.token-card {
  @apply bg-white rounded-2xl p-6 shadow-sm border border-gray-200;
  @apply hover:shadow-md transition-all duration-300;
}

.token-card-private {
  @apply bg-gradient-to-br from-gray-50 to-gray-100;
  @apply border-gray-300;
}

.balance-masked {
  @apply font-mono text-2xl text-gray-400 tracking-wider;
}
```

**Operation Panels**:
```css
.operation-panel {
  @apply bg-gray-50 rounded-2xl p-8 mt-6;
  @apply border-2 border-transparent;
  @apply transition-all duration-300;
}

.operation-panel-active {
  @apply border-blue-200 bg-blue-50;
}
```

**Progress Indicators**:
```css
.progress-bar {
  @apply relative h-2 bg-gray-200 rounded-full overflow-hidden;
}

.progress-fill {
  @apply absolute h-full bg-blue-500 rounded-full;
  @apply transition-all duration-500 ease-out;
}

.progress-text {
  @apply text-sm font-medium text-gray-600 mt-2;
}
```

### Animation Specifications

#### Token Flow Animation
```typescript
const tokenFlowVariants = {
  initial: { x: 0, opacity: 1 },
  animate: { 
    x: [0, 100, 200],
    opacity: [1, 0.5, 0],
    transition: {
      duration: 1.5,
      ease: "easeInOut"
    }
  }
};
```

#### Panel Transitions
```typescript
const panelVariants = {
  enter: { 
    opacity: 0, 
    y: 20,
    transition: { duration: 0.3 }
  },
  center: { 
    opacity: 1, 
    y: 0,
    transition: { duration: 0.3 }
  },
  exit: { 
    opacity: 0, 
    y: -20,
    transition: { duration: 0.2 }
  }
};
```

## Implementation Roadmap

### Phase 1: Foundation (Week 1)
**Focus**: Scaffold-ETH 2 setup and core infrastructure

**Deliverables**:
- [ ] Scaffold-ETH 2 project initialization
- [ ] Smart contract integration (already deployed)
- [ ] Basic routing and layout
- [ ] Design system implementation
- [ ] Wallet connection flow

**Key Files**:
```
packages/nextjs/
├── pages/
│   └── shielding.tsx          # Main shielding interface
├── components/
│   ├── shielding/
│   │   ├── TokenPairCard.tsx
│   │   ├── OperationPanel.tsx
│   │   └── ProgressTracker.tsx
│   └── common/
│       ├── LoadingStates.tsx
│       └── ErrorBoundary.tsx
└── hooks/
    ├── usePrivateBalance.ts
    └── useMPCOperations.ts
```

### Phase 2: Shielding Interface (Week 2)
**Focus**: Primary shielding screen implementation

**Deliverables**:
- [ ] Token pair card components
- [ ] Shield operation panel
- [ ] Progress tracking system
- [ ] Animation implementation
- [ ] Balance display logic

**Technical Tasks**:
```typescript
// Core hook implementation
export const useShieldingOperation = () => {
  const [progress, setProgress] = useState(0);
  const [status, setStatus] = useState<OperationStatus>("idle");
  
  const shield = async (amount: bigint) => {
    setStatus("approving");
    setProgress(20);
    // ... implementation
  };
  
  return { shield, progress, status };
};
```

### Phase 3: Advanced Operations (Week 3)
**Focus**: Unshield and transfer functionality

**Deliverables**:
- [ ] Unshield operation with MPC
- [ ] Private token transfers
- [ ] User onboarding flow
- [ ] Balance decryption UI
- [ ] Error handling

### Phase 4: Transaction History (Week 4)
**Focus**: History and data visualization

**Deliverables**:
- [ ] Transaction history component
- [ ] Subgraph integration
- [ ] Search and filtering
- [ ] Export functionality
- [ ] Mobile optimization

### Phase 5: Polish & Testing (Week 5)
**Focus**: Final polish and testing

**Deliverables**:
- [ ] Comprehensive testing
- [ ] Performance optimization
- [ ] Accessibility audit
- [ ] Documentation
- [ ] Deployment preparation

## Testing Strategy

### Unit Testing
```typescript
// Example test for shielding operation
describe("ShieldingOperation", () => {
  it("should show correct progress stages", async () => {
    const { result } = renderHook(() => useShieldingOperation());
    
    act(() => {
      result.current.shield(parseEther("100"));
    });
    
    expect(result.current.progress).toBe(20);
    expect(result.current.status).toBe("approving");
  });
});
```

### Integration Testing
- Full user flows with Cypress
- Smart contract interaction testing
- MPC service integration tests
- Error scenario testing

### User Acceptance Testing
- Professional UI/UX validation
- Loading state verification
- Error message clarity
- Mobile responsiveness
- Performance benchmarks

## Risk Mitigation

### Technical Risks

#### R-001: MPC Service Latency
**Mitigation**: 
- Implement optimistic UI updates
- Add clear loading indicators
- Cache decrypted balances
- Provide manual retry options

#### R-002: Transaction Failures
**Mitigation**:
- Comprehensive error messages
- Automatic retry with exponential backoff
- Transaction history for debugging
- Clear recovery instructions

### UX Risks

#### R-003: User Confusion
**Mitigation**:
- Progressive disclosure of complex features
- Inline help tooltips
- Clear operation descriptions
- Visual progress indicators

## Success Metrics

### Technical Metrics
- **Operation Success Rate**: > 95%
- **Average Operation Time**: < 30 seconds
- **Page Load Time**: < 2 seconds
- **Error Rate**: < 2%

### User Experience Metrics
- **Time to First Operation**: < 2 minutes
- **Operation Completion Rate**: > 90%
- **User Error Rate**: < 5%
- **Support Tickets**: < 1% of users

### Business Metrics
- **Daily Active Users**: Track growth
- **Shield/Unshield Volume**: Monitor adoption
- **User Retention**: > 80% weekly
- **Feature Usage**: Track operation distribution

## Conclusion

This enhanced PDR provides a comprehensive blueprint for building a professional, user-friendly shielding interface on Scaffold-ETH 2. The focus on exceptional UX, clear progress tracking, and professional polish ensures users can confidently perform privacy operations without confusion.

The phased implementation approach allows for iterative development while maintaining high quality standards. By leveraging Scaffold-ETH 2's built-in capabilities and focusing on the core shielding functionality, we can deliver a best-in-class privacy wallet interface.

### Next Steps
1. Set up Scaffold-ETH 2 development environment
2. Implement design system and component library
3. Begin Phase 1 development
4. Establish testing framework
5. Set up continuous deployment pipeline

---

**Document Control**
- **Version**: 2.0
- **Last Updated**: January 2025
- **Platform**: Scaffold-ETH 2
- **Status**: Ready for Implementation