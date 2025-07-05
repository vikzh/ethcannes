import React from "react";

interface MintFormProps {
  mintAmount: string;
  isMinting: boolean;
  onMintAmountChange: (value: string) => void;
  onMint: () => void;
}

export const MintForm: React.FC<MintFormProps> = ({
  mintAmount,
  isMinting,
  onMintAmountChange,
  onMint,
}) => {
  const isValidAmount = mintAmount && Number(mintAmount) > 0;

  return (
    <div className="space-y-4">
      <div>
        <label className="block text-sm font-medium text-gray-700 mb-2">
          Amount to mint
        </label>
        <input
          type="number"
          className="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-soda-blue-600 focus:border-transparent"
          placeholder="Enter amount"
          value={mintAmount}
          onChange={e => onMintAmountChange(e.target.value)}
        />
      </div>

      {isValidAmount ? (
        <button
          className="w-full py-3 bg-soda-blue-900 text-white rounded-xl hover:bg-soda-blue-800 transition-colors font-medium"
          onClick={onMint}
          disabled={isMinting}
        >
          {isMinting ? "Minting..." : "Mint"}
        </button>
      ) : (
        <button
          className="w-full py-3 bg-gray-300 text-gray-500 rounded-xl font-medium"
          disabled
        >
          Enter amount to mint
        </button>
      )}
    </div>
  );
}; 