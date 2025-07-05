import React from "react";
import TransactionAnimation from "../../animations/TransactionAnimation";
import { formatPrivateBalance, getUserKeyFromStorage } from "../../../utils/enc/cryptoUtils";
import { NetworkTokenData, TokenPair } from "../../../hooks/mpc";

interface UnshieldFormProps {
  unshieldAmount: string;
  isUnshielding: boolean;
  currentNetworkData: NetworkTokenData | undefined;
  currentTokenPair?: TokenPair;
  onUnshieldAmountChange: (value: string) => void;
  onUnshield: () => void;
}

export const UnshieldForm: React.FC<UnshieldFormProps> = ({
  unshieldAmount,
  isUnshielding,
  currentNetworkData,
  currentTokenPair,
  onUnshieldAmountChange,
  onUnshield,
}) => {
  const getAvailableToUnshield = () => {
    if (!getUserKeyFromStorage()) {
      return "*****";
    }
    
    // Use individual token balance if available, fallback to network data
    const balance = currentTokenPair?.privateTokenBalance || currentNetworkData?.privateTokenBalance;
    const decimals = currentTokenPair?.data.privateTokenDecimals || currentNetworkData?.privateTokenDecimals;
    
    return balance && decimals !== null
      ? formatPrivateBalance(balance, decimals || 5)
      : "*****";
  };

  const isValidAmount = unshieldAmount && Number(unshieldAmount) > 0;

  return (
    <div className="space-y-4">
      <TransactionAnimation isActive={isUnshielding} />
      <div>
        <div className="flex justify-between text-sm text-gray-600 mb-2">
          <span>Available to Unshield:</span>
          <span>{getAvailableToUnshield()}</span>
        </div>
        <input
          type="number"
          className="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-soda-blue-600 focus:border-transparent"
          placeholder="Amount to unshield"
          value={unshieldAmount}
          onChange={e => onUnshieldAmountChange(e.target.value)}
        />
      </div>

      {isValidAmount ? (
        <button
          className="w-full py-3 bg-soda-blue-900 text-white rounded-xl hover:bg-soda-blue-800 transition-colors font-medium"
          onClick={onUnshield}
          disabled={isUnshielding || !getUserKeyFromStorage()}
        >
          {isUnshielding ? "Unshielding..." : "Unshield"}
        </button>
      ) : (
        <button
          className="w-full py-3 bg-gray-300 text-gray-500 rounded-xl font-medium"
          disabled
        >
          Enter amount to unshield
        </button>
      )}
    </div>
  );
}; 