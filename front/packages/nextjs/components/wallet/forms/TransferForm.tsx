import React from "react";
import { ethers } from "ethers";
import { isValidAddress, formatPrivateBalance } from "../../../utils/enc/cryptoUtils";
import { NetworkTokenData, TokenPair } from "../../../hooks/mpc";

interface TransferFormProps {
  type: "clear" | "private";
  recipient: string;
  amount: string;
  isTransferring: boolean;
  currentNetworkData: NetworkTokenData | undefined;
  currentTokenPair?: TokenPair;
  onRecipientChange: (value: string) => void;
  onAmountChange: (value: string) => void;
  onSubmit: () => void;
}

export const TransferForm: React.FC<TransferFormProps> = ({
  type,
  recipient,
  amount,
  isTransferring,
  currentNetworkData,
  currentTokenPair,
  onRecipientChange,
  onAmountChange,
  onSubmit,
}) => {
  const getAvailableBalance = () => {
    if (type === "clear") {
      // Use individual token balance if available, fallback to network data
      const balance = currentTokenPair?.clearTokenBalance || currentNetworkData?.clearTokenBalance;
      const decimals = currentTokenPair?.data.clearTokenDecimals || currentNetworkData?.clearTokenDecimals;
      return balance && decimals !== null
        ? ethers.formatUnits(balance, decimals)
        : "0";
    } else {
      // Use individual token balance if available, fallback to network data
      const balance = currentTokenPair?.privateTokenBalance || currentNetworkData?.privateTokenBalance;
      const decimals = currentTokenPair?.data.privateTokenDecimals || currentNetworkData?.privateTokenDecimals;
      return balance && decimals !== null
        ? formatPrivateBalance(balance, decimals || 5)
        : "*****";
    }
  };

  const isFormValid = amount && recipient && isValidAddress(recipient);

  return (
    <div className="space-y-4">
      <div>
        <label className="block text-sm font-medium text-gray-700 mb-2">
          Recipient Address
        </label>
        <input
          type="text"
          className={`w-full px-4 py-3 border rounded-xl focus:ring-2 focus:border-transparent ${
            recipient && !isValidAddress(recipient)
              ? "border-red-300 focus:ring-red-500"
              : "border-gray-200 focus:ring-soda-blue-600"
          }`}
          placeholder="0x..."
          value={recipient}
          onChange={e => onRecipientChange(e.target.value)}
        />
        {recipient && !isValidAddress(recipient) && (
          <p className="text-red-500 text-sm mt-1">
            Please enter a valid Ethereum address
          </p>
        )}
      </div>

      <div>
        <label className="block text-sm font-medium text-gray-700 mb-2">Amount</label>
        <input
          type="number"
          className="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-soda-blue-600 focus:border-transparent"
          placeholder="Enter amount"
          value={amount}
          onChange={e => onAmountChange(e.target.value)}
        />
        <p className="text-sm text-gray-500 mt-1">
          Available: {getAvailableBalance()}
        </p>
      </div>

      {isFormValid ? (
        <button
          className="w-full py-3 bg-soda-blue-900 text-white rounded-xl hover:bg-soda-blue-800 transition-colors font-medium"
          onClick={onSubmit}
          disabled={isTransferring}
        >
          {isTransferring ? "Sending..." : "Send"}
        </button>
      ) : (
        <button
          className="w-full py-3 bg-gray-300 text-gray-500 rounded-xl font-medium"
          disabled
        >
          {!recipient || !isValidAddress(recipient)
            ? "Enter valid recipient address"
            : "Enter amount"}
        </button>
      )}
    </div>
  );
}; 