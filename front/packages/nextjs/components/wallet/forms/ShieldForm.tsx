import React, { useState } from "react";
import { ethers } from "ethers";
import { NetworkTokenData, TokenPair } from "../../../hooks/mpc";
import dynamic from 'next/dynamic';

// Dynamically import the animation component with no SSR
const EncryptionAnimation = dynamic(
  () => import('../../animations/EncryptionAnimation'),
  { ssr: false }
);

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

  const [isProcessing, setIsProcessing] = useState(false);
  const [transactionHash, setTransactionHash] = useState<string | null>(null);

  const handleShieldClick = async () => {
    try {
      setIsProcessing(true);
      setTransactionHash(null);
      
      // Call the onShield function and wait for it to complete
      await onShield();
      
      // If you have access to the transaction hash, you can set it here
      // For example: setTransactionHash(tx.hash);
      
    } catch (error) {
      console.error('Transaction failed:', error);
    } finally {
      // Optionally, you might want to keep showing the animation for a bit
      // or until you get a confirmation
      setTimeout(() => {
        setIsProcessing(false);
      }, 2000); // Show for at least 2 seconds
    }
  };

  return (
    <div className="space-y-4">
      {(isShielding || isProcessing) && (
        <div className="mt-4 transition-all duration-300">
          <EncryptionAnimation isActive={isShielding || isProcessing} />
          <p className="text-center text-gray-600 text-xs mt-2">
            {transactionHash 
              ? `Processing transaction... ${transactionHash.slice(0, 8)}...${transactionHash.slice(-6)}`
              : 'Confirming transaction...'}
          </p>
        </div>
      )}
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