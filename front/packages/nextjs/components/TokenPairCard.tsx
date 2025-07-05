import React from "react";
import { Address, parseAbi } from "viem";
import { useAccount, useReadContract } from "wagmi";
import usePrivateBalance from "~~/hooks/usePrivateBalance";

export type TokenPairCardProps = {
  clearTokenAddress: Address;
  privateTokenAddress: Address;
  tokenName?: string;
  tokenSymbol?: string;
};

export const TokenPairCard: React.FC<TokenPairCardProps> = ({
  clearTokenAddress,
  privateTokenAddress,
  tokenName,
  tokenSymbol,
}) => {
  const { address: userAddress } = useAccount();
  
  // ERC20 ABI for clear token interactions
  const erc20Abi = parseAbi([
    "function name() view returns (string)",
    "function symbol() view returns (string)",
    "function decimals() view returns (uint8)",
    "function balanceOf(address) view returns (uint256)",
  ]);
  
  // Clear token balance
  const { data: clearBalance, isLoading: isLoadingClear } = useReadContract({
    address: clearTokenAddress,
    abi: erc20Abi,
    functionName: "balanceOf",
    args: [userAddress!],
    query: {
      enabled: !!userAddress && clearTokenAddress !== "0x0000000000000000000000000000000000000000",
    },
  });

  // Private token balance
  const {
    encrypted,
    decrypted,
    isDecrypting,
    hasDecryptedBalance,
    formattedBalance,
    decryptBalance,
    error: balanceError,
  } = usePrivateBalance(privateTokenAddress);

  // Token metadata
  const { data: name } = useReadContract({
    address: clearTokenAddress,
    abi: erc20Abi,
    functionName: "name",
    query: {
      enabled: clearTokenAddress !== "0x0000000000000000000000000000000000000000",
    },
  });

  const { data: symbol } = useReadContract({
    address: clearTokenAddress,
    abi: erc20Abi,
    functionName: "symbol",
    query: {
      enabled: clearTokenAddress !== "0x0000000000000000000000000000000000000000",
    },
  });

  const { data: decimals } = useReadContract({
    address: clearTokenAddress,
    abi: erc20Abi,
    functionName: "decimals",
    query: {
      enabled: clearTokenAddress !== "0x0000000000000000000000000000000000000000",
    },
  });

  // Format clear balance for display
  const formatClearBalance = (balance: bigint | undefined, decimals: number = 18) => {
    if (!balance) return "0.00";
    
    const divisor = BigInt(10 ** decimals);
    const whole = balance / divisor;
    const fraction = balance % divisor;
    
    return `${whole}.${fraction.toString().padStart(decimals, "0").slice(0, 5)}`;
  };

  const handleDecryptBalance = async () => {
    // TODO: Get user key from secure storage
    const userKey = "placeholder_key";
    await decryptBalance(userKey);
  };

  return (
    <div className="flex justify-center items-center gap-8 p-6">
      {/* Clear Token Card */}
      <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-200 hover:shadow-md transition-all duration-300 min-w-[280px]">
        <div className="text-center">
          <div className="flex items-center justify-center mb-4">
            <div className="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center">
              <span className="text-blue-600 font-bold text-lg">C</span>
            </div>
          </div>
          
          <h3 className="text-lg font-semibold text-gray-900 mb-2">
            Clear {tokenName || name || "Token"}
          </h3>
          
          <div className="text-3xl font-bold text-gray-900 mb-1">
            {isLoadingClear ? (
              <div className="animate-pulse bg-gray-200 h-8 w-24 mx-auto rounded"></div>
            ) : (
              formatClearBalance(clearBalance, Number(decimals) || 18)
            )}
          </div>
          
          <div className="text-sm text-gray-500 uppercase tracking-wide">
            {tokenSymbol || symbol || "TOKEN"}
          </div>
          
          <div className="mt-4 text-xs text-gray-400">
            Public Balance
          </div>
        </div>
      </div>

      {/* Arrow Indicator */}
      <div className="flex flex-col items-center">
        <div className="text-2xl text-gray-400">⇄</div>
        <div className="text-xs text-gray-500 mt-1">Shield/Unshield</div>
      </div>

      {/* Private Token Card */}
      <div className="bg-gradient-to-br from-gray-50 to-gray-100 rounded-2xl p-6 border border-gray-300 hover:shadow-md transition-all duration-300 min-w-[280px]">
        <div className="text-center">
          <div className="flex items-center justify-center mb-4">
            <div className="w-12 h-12 bg-gray-200 rounded-full flex items-center justify-center">
              <span className="text-gray-600 font-bold text-lg">P</span>
            </div>
          </div>
          
          <h3 className="text-lg font-semibold text-gray-900 mb-2">
            Private {tokenName || name || "Token"}
          </h3>
          
          <div className="text-3xl font-bold text-gray-700 mb-1">
            {!hasDecryptedBalance ? (
              <div className="font-mono text-gray-400 tracking-wider">
                *****
              </div>
            ) : (
              formattedBalance
            )}
          </div>
          
          <div className="text-sm text-gray-500 uppercase tracking-wide">
            p{tokenSymbol || symbol || "TOKEN"}
          </div>
          
          <div className="mt-4">
            {!hasDecryptedBalance ? (
              <button
                onClick={handleDecryptBalance}
                disabled={isDecrypting || !encrypted}
                className="px-4 py-2 bg-gray-600 text-white text-sm rounded-lg hover:bg-gray-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors duration-200"
              >
                {isDecrypting ? (
                  <span className="flex items-center gap-2">
                    <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
                    Decrypting...
                  </span>
                ) : (
                  "Decrypt Balance"
                )}
              </button>
            ) : (
              <div className="text-xs text-gray-500">
                Private Balance Decrypted
              </div>
            )}
          </div>
          
          {balanceError && (
            <div className="mt-2 text-xs text-red-500">
              {balanceError}
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default TokenPairCard;