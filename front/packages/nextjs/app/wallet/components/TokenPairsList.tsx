"use client";
import React, { useState } from "react";
import { TokenPairCard, ActionPanel, BottomPanelType } from "../../../components/wallet";
import { TokenPair } from "../../../hooks/mpc";
import { useWalletActions } from "../../../hooks/wallet/useWalletActions";

interface Props {
  chainId: number;
  filteredTokenPairs: TokenPair[];
  isRefreshingBalance: boolean;
  clickedButton: { action: string; networkId: number; index: number } | null;
  onNetworkSwitch: (targetChainId: number, action: string, index: number) => void;
  updateTokenPairBalance: (privateAddress: string, updates: Partial<any>) => void;
  handlePrivateBalanceDecrypt: (targetChainId: number, privateTokenAddress?: string) => void;
  handleOnboardClick: () => void;
  networkTokenData: Record<number, any>;
}

const TokenPairsList: React.FC<Props> = ({
  chainId,
  filteredTokenPairs,
  isRefreshingBalance,
  clickedButton,
  onNetworkSwitch,
  updateTokenPairBalance,
  handlePrivateBalanceDecrypt,
  handleOnboardClick,
  networkTokenData,
}) => {
  const [bottomPanelType, setBottomPanelType] = useState<BottomPanelType>("hidden");
  const [activeRowIndex, setActiveRowIndex] = useState<number | null>(null);
  const [activeNetworkId, setActiveNetworkId] = useState<number | null>(null);

  const [recipient, setRecipient] = useState("");
  const [amount, setAmount] = useState("");
  const [shieldAmount, setShieldAmount] = useState("");
  const [unshieldAmount, setUnshieldAmount] = useState("");
  const [mintAmount, setMintAmount] = useState("");

  const {
    approvingTokens,
    isTransferring,
    isShielding,
    isUnshielding,
    isMinting,
    shieldError,
    handleApprove,
    transferClear,
    transferPrivate,
    shield,
    unshield,
    mint,
  } = useWalletActions(updateTokenPairBalance, () => {});

  const handleSetBottomPanel = (type: BottomPanelType, index: number, networkId: number) => {
    if (bottomPanelType === type && activeRowIndex === index && activeNetworkId === networkId) {
      handleClosePanel();
    } else {
      setBottomPanelType(type);
      setActiveRowIndex(index);
      setActiveNetworkId(networkId);
    }
  };

  const handleClosePanel = () => {
    setBottomPanelType("hidden");
    setActiveRowIndex(null);
    setActiveNetworkId(null);
    setAmount("");
    setRecipient("");
    setShieldAmount("");
    setUnshieldAmount("");
    setMintAmount("");
  };

  const getCurrentNetworkData = () => networkTokenData[chainId];

  if (filteredTokenPairs.length === 0) {
    return (
      <div className="text-center py-8">
        <div className="mb-4">
          <svg className="mx-auto h-16 w-16 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
        </div>
        <h3 className="text-lg font-medium text-gray-900 mb-2">No tokens available</h3>
        <p className="text-gray-500 max-w-md mx-auto">
          Either no contracts are deployed on the selected networks, or all networks are filtered out.
        </p>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {filteredTokenPairs.map((pair, index) => (
        <React.Fragment key={`${pair.clearAddress}-${pair.privateAddress}-${index}`}>
          <TokenPairCard
            pair={pair}
            index={index}
            chainId={chainId}
            bottomPanelType={bottomPanelType}
            activeRowIndex={activeRowIndex}
            activeNetworkId={activeNetworkId}
            isRefreshingBalance={isRefreshingBalance}
            clickedButton={clickedButton}
            onNetworkSwitch={onNetworkSwitch}
            onSetBottomPanel={handleSetBottomPanel}
            onPrivateBalanceDecrypt={handlePrivateBalanceDecrypt}
            onPrivateBalanceClear={privateAddress => updateTokenPairBalance(privateAddress, { privateTokenBalance: undefined })}
            onOnboard={handleOnboardClick}
          />

          {activeRowIndex === index && activeNetworkId === pair.chainId && (
            <ActionPanel
              bottomPanelType={bottomPanelType}
              currentNetworkData={getCurrentNetworkData()}
              currentTokenPair={pair}
              recipient={recipient}
              amount={amount}
              isTransferring={isTransferring}
              onRecipientChange={setRecipient}
              onAmountChange={setAmount}
              onTransferClear={() => transferClear(pair, amount, recipient)}
              onTransferPrivate={() => transferPrivate(pair, amount, recipient)}
              shieldAmount={shieldAmount}
              isShielding={isShielding}
              isApproving={approvingTokens.has(pair.privateAddress)}
              shieldError={shieldError}
              onShieldAmountChange={setShieldAmount}
              onApprove={() => handleApprove(pair)}
              onShield={() => shield(pair, shieldAmount)}
              unshieldAmount={unshieldAmount}
              isUnshielding={isUnshielding}
              onUnshieldAmountChange={setUnshieldAmount}
              onUnshield={() => unshield(pair, unshieldAmount)}
              mintAmount={mintAmount}
              isMinting={isMinting}
              onMintAmountChange={setMintAmount}
              onMint={() => mint(pair, mintAmount)}
              onClose={handleClosePanel}
            />
          )}
        </React.Fragment>
      ))}
    </div>
  );
};

export default TokenPairsList; 