"use client";

import React, { useEffect, useState } from "react";
import { ActionPanel, BottomPanelType, TokenPairCard } from "../../../components/wallet";
import { TokenPair } from "../../../hooks/mpc";
import { useWalletActions } from "../../../hooks/wallet/useWalletActions";

// Token logo mapping - same as in TokenPairCard
export const TOKEN_LOGOS: Record<string, string> = {
  "0x331dacc9928d783c34b6b0f3961cad4a948155af": "https://etherscan.io/token/images/usdc_ofc_32.svg",
  "0x353f9140fd398ec8ec16d3cc72c7d7db61c93a41": "https://etherscan.io/token/images/weth_28.png?v=2",
};

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
  const [selectedTokenIndex, setSelectedTokenIndex] = useState<number>(0);

  const [recipient, setRecipient] = useState("");
  const [amount, setAmount] = useState("");
  const [shieldAmount, setShieldAmount] = useState("");
  const [unshieldAmount, setUnshieldAmount] = useState("");
  const [mintAmount, setMintAmount] = useState("");

  // Reset selected token index if it's out of bounds
  useEffect(() => {
    if (selectedTokenIndex >= filteredTokenPairs.length && filteredTokenPairs.length > 0) {
      setSelectedTokenIndex(0);
    }
  }, [filteredTokenPairs.length, selectedTokenIndex]);

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
    isTokenApproved,
    refreshAllowance,
  } = useWalletActions(updateTokenPairBalance, handleClosePanel);

  const handleSetBottomPanel = (type: BottomPanelType, index: number, networkId: number) => {
    if (bottomPanelType === type && activeRowIndex === index && activeNetworkId === networkId) {
      handleClosePanel();
    } else {
      setBottomPanelType(type);
      setActiveRowIndex(index);
      setActiveNetworkId(networkId);
    }
  };

  const getCurrentNetworkData = () => networkTokenData[chainId];

  if (filteredTokenPairs.length === 0) {
    return (
      <div className="text-center py-8">
        <div className="mb-4">
          <svg className="mx-auto h-16 w-16 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth={1}
              d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
            />
          </svg>
        </div>
        <h3 className="text-lg font-medium text-gray-900 mb-2">No tokens available</h3>
        <p className="text-gray-500 max-w-md mx-auto">
          Either no contracts are deployed on the selected networks, or all networks are filtered out.
        </p>
      </div>
    );
  }

  const selectedPair = filteredTokenPairs[selectedTokenIndex];

  return (
    <div className="space-y-6">
      {/* Token Selector - only show if multiple tokens */}
      {filteredTokenPairs.length > 1 && (
        <div className="flex justify-start">
          <div className="relative w-full max-w-[140px]">
            <select
              value={selectedTokenIndex}
              onChange={e => {
                const newIndex = parseInt(e.target.value);
                setSelectedTokenIndex(newIndex);
                // Close action panel when switching tokens
                handleClosePanel();
              }}
              className="block w-full pl-9 pr-7 py-2 text-sm border border-gray-300 rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-soda-blue-500 focus:border-soda-blue-500 appearance-none cursor-pointer"
            >
              {filteredTokenPairs.map((pair, index) => (
                <option key={`${pair.clearAddress}-${pair.privateAddress}-${index}`} value={index}>
                  {pair.data.clearTokenSymbol || "..."}
                </option>
              ))}
            </select>

            {/* Selected token icon */}
            <div className="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-2.5">
              {TOKEN_LOGOS[selectedPair.clearAddress.toLowerCase()] ? (
                <img
                  src={TOKEN_LOGOS[selectedPair.clearAddress.toLowerCase()]}
                  alt={selectedPair.data.clearTokenSymbol ?? "token"}
                  className="w-4 h-4 object-contain"
                />
              ) : (
                <div className="w-4 h-4 rounded-full bg-soda-blue-900 flex items-center justify-center">
                  <span className="text-white font-bold text-xs">
                    {selectedPair.data.clearTokenSymbol?.charAt(0) ?? "T"}
                  </span>
                </div>
              )}
            </div>

            {/* Dropdown arrow */}
            <div className="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-700">
              <svg className="fill-current h-3 w-3" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20">
                <path d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" />
              </svg>
            </div>
          </div>
        </div>
      )}

      {/* Token Pair Card */}
      {selectedPair && (
        <React.Fragment>
          <TokenPairCard
            pair={selectedPair}
            index={selectedTokenIndex}
            chainId={chainId}
            bottomPanelType={bottomPanelType}
            activeRowIndex={activeRowIndex}
            activeNetworkId={activeNetworkId}
            isRefreshingBalance={isRefreshingBalance}
            clickedButton={clickedButton}
            onNetworkSwitch={onNetworkSwitch}
            onSetBottomPanel={handleSetBottomPanel}
            onPrivateBalanceDecrypt={handlePrivateBalanceDecrypt}
            onPrivateBalanceClear={privateAddress =>
              updateTokenPairBalance(privateAddress, { privateTokenBalance: undefined })
            }
            onOnboard={handleOnboardClick}
          />

          {activeRowIndex === selectedTokenIndex && activeNetworkId === selectedPair.chainId && (
            <ActionPanel
              bottomPanelType={bottomPanelType}
              currentNetworkData={getCurrentNetworkData()}
              currentTokenPair={selectedPair}
              recipient={recipient}
              amount={amount}
              isTransferring={isTransferring}
              onRecipientChange={setRecipient}
              onAmountChange={setAmount}
              onTransferClear={() => transferClear(selectedPair, amount, recipient)}
              onTransferPrivate={() => transferPrivate(selectedPair, amount, recipient)}
              shieldAmount={shieldAmount}
              isShielding={isShielding}
              isApproving={approvingTokens.has(selectedPair.privateAddress)}
              isApproved={isTokenApproved(selectedPair.privateAddress)}
              shieldError={shieldError}
              onShieldAmountChange={setShieldAmount}
              onApprove={() => {
                handleApprove(selectedPair).then(() => refreshAllowance(selectedPair));
              }}
              onShield={() => shield(selectedPair, shieldAmount)}
              unshieldAmount={unshieldAmount}
              isUnshielding={isUnshielding}
              onUnshieldAmountChange={setUnshieldAmount}
              onUnshield={() => unshield(selectedPair, unshieldAmount)}
              mintAmount={mintAmount}
              isMinting={isMinting}
              onMintAmountChange={setMintAmount}
              onMint={() => mint(selectedPair, mintAmount)}
              onClose={handleClosePanel}
            />
          )}
        </React.Fragment>
      )}
    </div>
  );
};

export default TokenPairsList;
