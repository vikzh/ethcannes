import React from "react";
import { ethers } from "ethers";
import { NetworkTokenData, TokenPair } from "../../../hooks/mpc";
import TransactionAnimation from "../../animations/TransactionAnimation";

interface ShieldFormProps {
  shieldAmount: string;
  isShielding: boolean;
  isApproving: boolean;
  shieldError?: string;
  currentNetworkData: NetworkTokenData | undefined;
  currentTokenPair?: TokenPair;
  isApproved: boolean;
  onShieldAmountChange: (value: string) => void;
  onApprove: () => void;
  onShield: () => void;
}

export const ShieldForm: React.FC<ShieldFormProps> = ({
  shieldAmount,
  isShielding,
  isApproving,
  shieldError,
  currentNetworkData,
  currentTokenPair,
  isApproved,
  onShieldAmountChange,
  onApprove,
  onShield,
}) => {
  const getAvailableToShield = () => {
    // Use individual token balance if available, fallback to network data
    const balance = currentTokenPair?.clearTokenBalance || currentNetworkData?.clearTokenBalance;
    const decimals = currentTokenPair?.data.clearTokenDecimals || currentNetworkData?.clearTokenDecimals;
    
    return balance &&
      decimals !== null &&
      !isNaN(Number(balance))
      ? ethers.formatUnits(balance, decimals)
      : "0.0";
  };

  const isValidAmount = shieldAmount && Number(shieldAmount) > 0;

  const handleShieldClick = async () => {
    try {
      await onShield();
    } catch (error) {
      console.error("Shield transaction failed:", error);
    }
  };

  return (
    <div className="space-y-4">
      <TransactionAnimation isActive={isShielding} />
      {isApproved && (
        <div>
          <div className="flex justify-between text-sm text-gray-600 mb-2">
            <span>Available to Shield:</span>
            <span>{getAvailableToShield()}</span>
          </div>
          <input
            type="number"
            className="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-soda-blue-600 focus:border-transparent"
            placeholder="Amount to shield"
            value={shieldAmount}
            onChange={e => onShieldAmountChange(e.target.value)}
          />
        </div>
      )}

      {isApproved ? (
        isValidAmount ? (
          <button
            className="w-full py-3 bg-soda-blue-900 text-white rounded-xl hover:bg-soda-blue-800 transition-colors font-medium"
            onClick={handleShieldClick}
            disabled={isShielding}
          >
            {isShielding ? "Shielding..." : "Shield"}
          </button>
        ) : (
          <button
            className="w-full py-3 bg-gray-300 text-gray-500 rounded-xl font-medium"
            disabled
          >
            Enter amount to shield
          </button>
        )
      ) : (
        <button
          className="w-full py-3 bg-soda-blue-900 text-white rounded-xl hover:bg-soda-blue-800 transition-colors font-medium"
          onClick={onApprove}
          disabled={isApproving}
        >
          {isApproving ? "Approving..." : "Approve Tokens"}
        </button>
      )}
      
      {shieldError && (
        <div className="text-red-500 text-sm">{shieldError}</div>
      )}
    </div>
  );
}; 