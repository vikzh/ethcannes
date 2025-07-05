import React from "react";
import { NetworkTokenData, TokenPair } from "../../hooks/mpc";
import { MintForm } from "./forms/MintForm";
import { TransferForm } from "./forms/TransferForm";
import { ShieldForm } from "./forms/ShieldForm";
import { UnshieldForm } from "./forms/UnshieldForm";

export type BottomPanelType = "hidden" | "transfer-clear" | "transfer-private" | "shield" | "unshield" | "mint";

interface ActionPanelProps {
  bottomPanelType: BottomPanelType;
  currentNetworkData: NetworkTokenData | undefined;
  currentTokenPair?: TokenPair;
  // Transfer form props
  recipient: string;
  amount: string;
  isTransferring: boolean;
  onRecipientChange: (value: string) => void;
  onAmountChange: (value: string) => void;
  onTransferClear: () => void;
  onTransferPrivate: () => void;
  // Shield form props
  shieldAmount: string;
  isShielding: boolean;
  isApproving: boolean;
  shieldError?: string;
  onShieldAmountChange: (value: string) => void;
  onApprove: () => void;
  onShield: () => void;
  // Unshield form props
  unshieldAmount: string;
  isUnshielding: boolean;
  onUnshieldAmountChange: (value: string) => void;
  onUnshield: () => void;
  // Mint form props
  mintAmount: string;
  isMinting: boolean;
  onMintAmountChange: (value: string) => void;
  onMint: () => void;
  // Panel controls
  onClose: () => void;
}

export const ActionPanel: React.FC<ActionPanelProps> = ({
  bottomPanelType,
  currentNetworkData,
  currentTokenPair,
  recipient,
  amount,
  isTransferring,
  onRecipientChange,
  onAmountChange,
  onTransferClear,
  onTransferPrivate,
  shieldAmount,
  isShielding,
  isApproving,
  shieldError,
  onShieldAmountChange,
  onApprove,
  onShield,
  unshieldAmount,
  isUnshielding,
  onUnshieldAmountChange,
  onUnshield,
  mintAmount,
  isMinting,
  onMintAmountChange,
  onMint,
  onClose,
}) => {
  if (bottomPanelType === "hidden") {
    return null;
  }

  const getPanelTitle = () => {
    switch (bottomPanelType) {
      case "transfer-clear":
        return "Send Clear Tokens";
      case "transfer-private":
        return "Send Private Tokens";
      case "shield":
        return "Shield Clear → Private";
      case "unshield":
        return "Unshield Private → Clear";
      case "mint":
        return "Mint Clear Tokens";
      default:
        return "";
    }
  };

  const renderForm = () => {
    switch (bottomPanelType) {
      case "transfer-clear":
        return (
          <TransferForm
            type="clear"
            recipient={recipient}
            amount={amount}
            isTransferring={isTransferring}
            currentNetworkData={currentNetworkData}
            currentTokenPair={currentTokenPair}
            onRecipientChange={onRecipientChange}
            onAmountChange={onAmountChange}
            onSubmit={onTransferClear}
          />
        );
      case "transfer-private":
        return (
          <TransferForm
            type="private"
            recipient={recipient}
            amount={amount}
            isTransferring={isTransferring}
            currentNetworkData={currentNetworkData}
            currentTokenPair={currentTokenPair}
            onRecipientChange={onRecipientChange}
            onAmountChange={onAmountChange}
            onSubmit={onTransferPrivate}
          />
        );
      case "shield":
        return (
          <ShieldForm
            shieldAmount={shieldAmount}
            isShielding={isShielding}
            isApproving={isApproving}
            shieldError={shieldError}
            currentNetworkData={currentNetworkData}
            currentTokenPair={currentTokenPair}
            onShieldAmountChange={onShieldAmountChange}
            onApprove={onApprove}
            onShield={onShield}
          />
        );
      case "unshield":
        return (
          <UnshieldForm
            unshieldAmount={unshieldAmount}
            isUnshielding={isUnshielding}
            currentNetworkData={currentNetworkData}
            currentTokenPair={currentTokenPair}
            onUnshieldAmountChange={onUnshieldAmountChange}
            onUnshield={onUnshield}
          />
        );
      case "mint":
        return (
          <MintForm
            mintAmount={mintAmount}
            isMinting={isMinting}
            onMintAmountChange={onMintAmountChange}
            onMint={onMint}
          />
        );
      default:
        return null;
    }
  };

  return (
    <div className="bg-gray-50 rounded-2xl p-6 mt-4 mb-4">
      <div className="flex justify-between items-center mb-4">
        <h3 className="text-lg font-semibold text-gray-900">
          {getPanelTitle()}
        </h3>
        <button
          className="w-8 h-8 rounded-full bg-gray-200 hover:bg-gray-300 flex items-center justify-center transition-colors"
          onClick={onClose}
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            strokeWidth={1.5}
            stroke="currentColor"
            className="w-4 h-4"
          >
            <path strokeLinecap="round" strokeLinejoin="round" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      </div>
      {renderForm()}
    </div>
  );
}; 