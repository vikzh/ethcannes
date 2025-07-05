"use client";

import React from "react";
import { getNetworkConfig } from "../../config/network";
import { HistoryTransaction, useTransactionHistory } from "../../hooks/mpc";
import { ethers } from "ethers";
import { useAccount, useChainId } from "wagmi";

// Helper function to format timestamp
const formatTimestamp = (timestamp: string) => {
  const date = new Date(parseInt(timestamp) * 1000);
  return date.toLocaleString();
};

// Helper function to format address for display
const formatAddress = (address: string) => {
  if (!address) return "Unknown";
  return `${address.slice(0, 6)}...${address.slice(-4)}`;
};

// Helper function to format amount
const formatAmount = (amount: string, decimals = 18) => {
  if (!amount || amount === "****") return amount;
  if (amount === "Error") return amount;
  try {
    return parseFloat(ethers.formatUnits(amount, decimals)).toFixed(4);
  } catch {
    return amount;
  }
};

// Helper function to get transaction type badge styling
const getTransactionTypeBadge = (type: HistoryTransaction["type"]) => {
  const baseClasses = "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium";
  
  switch (type) {
    case "Shield":
      return `${baseClasses} bg-blue-100 text-blue-800`;
    case "Unshield":
      return `${baseClasses} bg-green-100 text-green-800`;
    case "Transfer":
      return `${baseClasses} bg-purple-100 text-purple-800`;
    case "EncryptedTransfer":
      return `${baseClasses} bg-orange-100 text-orange-800`;
    case "UnshieldRequested":
      return `${baseClasses} bg-yellow-100 text-yellow-800`;
    case "UnshieldFailed":
      return `${baseClasses} bg-red-100 text-red-800`;
    default:
      return `${baseClasses} bg-gray-100 text-gray-800`;
  }
};

interface TransactionRowProps {
  transaction: HistoryTransaction;
  userAddress: string;
  explorerUrl: string;
  onDecrypt: (transaction: HistoryTransaction) => void;
}

const TransactionRow: React.FC<TransactionRowProps> = ({ transaction, userAddress, explorerUrl, onDecrypt }) => {
  const isUserSender = transaction.from?.toLowerCase() === userAddress.toLowerCase();
  const isUserRecipient = transaction.to?.toLowerCase() === userAddress.toLowerCase();
  
  return (
    <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-4 hover:shadow-md transition-shadow">
      <div className="flex items-center justify-between mb-3">
        <div className="flex items-center space-x-3">
          <span className={getTransactionTypeBadge(transaction.type)}>
            {transaction.type}
          </span>
          <span className="text-sm text-gray-500">
            {transaction.tokenName} ({transaction.tokenSymbol})
          </span>
        </div>
        <span className="text-sm text-gray-400">
          {formatTimestamp(transaction.blockTimestamp)}
        </span>
      </div>
      
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-3">
        <div>
          <span className="text-xs font-medium text-gray-500 uppercase tracking-wide">From</span>
          <div className="flex items-center mt-1">
            <span className={`text-sm ${isUserSender ? 'font-semibold text-soda-blue-600' : 'text-gray-700'}`}>
              {transaction.from ? formatAddress(transaction.from) : 'N/A'}
            </span>
            {isUserSender && (
              <span className="ml-2 text-xs bg-soda-blue-100 text-soda-blue-800 px-2 py-1 rounded">You</span>
            )}
          </div>
        </div>
        
        <div>
          <span className="text-xs font-medium text-gray-500 uppercase tracking-wide">To</span>
          <div className="flex items-center mt-1">
            <span className={`text-sm ${isUserRecipient ? 'font-semibold text-soda-blue-600' : 'text-gray-700'}`}>
              {transaction.to ? formatAddress(transaction.to) : 'N/A'}
            </span>
            {isUserRecipient && (
              <span className="ml-2 text-xs bg-soda-blue-100 text-soda-blue-800 px-2 py-1 rounded">You</span>
            )}
          </div>
        </div>
        
        <div>
          <span className="text-xs font-medium text-gray-500 uppercase tracking-wide">Amount</span>
          <div className="flex items-center mt-1">
            <span className={`text-sm font-medium ${
              transaction.amount === "Error" 
                ? "text-red-600" 
                : "text-gray-900"
            }`}>
              {formatAmount(transaction.amount || "0")} {transaction.tokenSymbol}
            </span>
            {transaction.canDecrypt && (transaction.amount === "****" || transaction.amount === "Error") && !transaction.isDecrypted && (
              <>
                {transaction.isDecrypting ? (
                  <div className="ml-2 flex items-center">
                    <svg
                      className="animate-spin h-3 w-3 text-soda-blue-600"
                      xmlns="http://www.w3.org/2000/svg"
                      fill="none"
                      viewBox="0 0 24 24"
                    >
                      <circle
                        className="opacity-25"
                        cx="12"
                        cy="12"
                        r="10"
                        stroke="currentColor"
                        strokeWidth="4"
                      />
                      <path
                        className="opacity-75"
                        fill="currentColor"
                        d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                      />
                    </svg>
                    <span className="ml-1 text-xs text-gray-500">Decrypting...</span>
                  </div>
                ) : (
                  <button 
                    onClick={() => onDecrypt(transaction)}
                    className={`ml-2 text-xs hover:underline ${
                      transaction.amount === "Error" 
                        ? "text-red-600 hover:text-red-800" 
                        : "text-soda-blue-600 hover:text-soda-blue-800"
                    }`}
                  >
                    {transaction.amount === "Error" ? "Retry" : "Decrypt"}
                  </button>
                )}
              </>
            )}
          </div>
        </div>
      </div>
      
      <div className="flex items-center justify-between text-xs text-gray-400">
        <span>Block #{transaction.blockNumber}</span>
        <a
          href={`${explorerUrl}/tx/${transaction.transactionHash}`}
          target="_blank"
          rel="noopener noreferrer"
          className="text-soda-blue-600 hover:text-soda-blue-800 underline"
        >
          View on Explorer
        </a>
      </div>
    </div>
  );
};

const HistoryPage = () => {
  const { address, isConnected } = useAccount();
  const chainId = useChainId();
  const { transactions, isLoading, error, refetch, decryptTransaction } = useTransactionHistory();
  
  // Get explorer URL for current network
  const networkConfig = getNetworkConfig(chainId);
  const explorerUrl = networkConfig.EXPLORER_URL || "";

  if (!isConnected) {
    return (
      <div className="flex flex-col items-center justify-start min-h-screen py-8">
        <div className="w-full max-w-4xl p-4">
          <div className="flex flex-col gap-6">
            <h1 className="text-3xl font-bold text-soda-blue-900">Transaction History</h1>
            <div className="bg-white rounded-3xl shadow-lg p-6">
              <p className="text-gray-500 text-center">Please connect your wallet to view transaction history.</p>
            </div>
          </div>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="flex flex-col items-center justify-start min-h-screen py-8">
        <div className="w-full max-w-4xl p-4">
          <div className="flex flex-col gap-6">
            <div className="flex items-center justify-between">
              <h1 className="text-3xl font-bold text-soda-blue-900">Transaction History</h1>
              <button
                onClick={refetch}
                className="px-4 py-2 bg-soda-blue-600 text-white rounded-lg hover:bg-soda-blue-700 transition-colors"
              >
                Retry
              </button>
            </div>
            <div className="bg-white rounded-3xl shadow-lg p-6">
              <div className="text-center py-8">
                <div className="mb-4">
                  <svg
                    className="mx-auto h-16 w-16 text-red-400"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={1}
                      d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                    />
                  </svg>
                </div>
                <h3 className="text-lg font-medium text-gray-900 mb-2">Error Loading Transactions</h3>
                <p className="text-gray-500 max-w-md mx-auto">{error}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="flex flex-col items-center justify-start min-h-screen py-8">
      <div className="w-full max-w-4xl p-4">
        <div className="flex flex-col gap-6">
          <div className="flex items-center justify-between">
            <h1 className="text-3xl font-bold text-soda-blue-900">Transaction History</h1>
            <button
              onClick={refetch}
              disabled={isLoading}
              className="px-4 py-2 bg-soda-blue-600 text-white rounded-lg hover:bg-soda-blue-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
            >
              {isLoading ? "Loading..." : "Refresh"}
            </button>
          </div>

          {isLoading ? (
            <div className="bg-white rounded-3xl shadow-lg p-6">
              <div className="text-center py-8">
                <div className="mb-4">
                  <svg
                    className="mx-auto h-16 w-16 text-gray-400 animate-spin"
                    fill="none"
                    viewBox="0 0 24 24"
                  >
                    <circle
                      className="opacity-25"
                      cx="12"
                      cy="12"
                      r="10"
                      stroke="currentColor"
                      strokeWidth="4"
                    />
                    <path
                      className="opacity-75"
                      fill="currentColor"
                      d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                    />
                  </svg>
                </div>
                <h3 className="text-lg font-medium text-gray-900 mb-2">Loading Transactions</h3>
                <p className="text-gray-500">Fetching your transaction history from the subgraph...</p>
              </div>
            </div>
          ) : transactions.length === 0 ? (
            <div className="bg-white rounded-3xl shadow-lg p-6">
              <div className="text-center py-8">
                <div className="mb-4">
                  <svg
                    className="mx-auto h-16 w-16 text-gray-400"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={1}
                      d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                    />
                  </svg>
                </div>
                <h3 className="text-lg font-medium text-gray-900 mb-2">No Transactions Found</h3>
                <p className="text-gray-500 max-w-md mx-auto">
                  You haven&apos;t made any transactions yet. Start by creating some tokens or making transfers to see your transaction history here.
                </p>
              </div>
            </div>
          ) : (
            <div className="bg-white rounded-3xl shadow-lg p-6">
              <div className="mb-6">
                <h2 className="text-lg font-semibold text-gray-900 mb-2">
                  Recent Transactions ({transactions.length})
                </h2>
                <p className="text-sm text-gray-500">
                  Showing transactions where you are the sender or recipient
                </p>
              </div>
              
              <div className="space-y-4">
                {transactions.map((transaction) => (
                  <TransactionRow
                    key={transaction.id}
                    transaction={transaction}
                    userAddress={address || ""}
                    explorerUrl={explorerUrl}
                    onDecrypt={decryptTransaction}
                  />
                ))}
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default HistoryPage;
