"use client";

import React, { useState } from "react";
import Head from "next/head";
import { useAccount } from "wagmi";
import TokenPairCard from "~~/components/TokenPairCard";
import usePrivateTokenFactory from "~~/hooks/usePrivateTokenFactory";

// Example token addresses (these would be dynamic in production)
const EXAMPLE_CLEAR_TOKEN = "0x0000000000000000000000000000000000000000" as const;
const EXAMPLE_PRIVATE_TOKEN = "0x0000000000000000000000000000000000000000" as const;

const ShieldingPage = () => {
  const { address: userAddress, isConnected } = useAccount();
  const { totalTokens, isLoadingTotal, factoryAddress } = usePrivateTokenFactory();
  
  const [selectedTokenPair, setSelectedTokenPair] = useState<{
    clear: string;
    private: string;
    name: string;
    symbol: string;
  } | null>(null);

  if (!isConnected) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <Head>
          <title>ETH Cannes - Token Shielding</title>
          <meta name="description" content="Privacy-focused token shielding interface" />
        </Head>
        
        <div className="text-center">
          <div className="w-24 h-24 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-6">
            <span className="text-blue-600 text-4xl">🛡️</span>
          </div>
          
          <h1 className="text-3xl font-bold text-gray-900 mb-4">
            ETH Cannes Privacy Wallet
          </h1>
          
          <p className="text-gray-600 mb-8 max-w-md">
            Connect your wallet to start shielding tokens and maintaining your privacy on Base Sepolia.
          </p>
          
          <div className="text-sm text-gray-500">
            Please connect your wallet to continue
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <Head>
        <title>ETH Cannes - Token Shielding</title>
        <meta name="description" content="Privacy-focused token shielding interface" />
      </Head>

      {/* Header */}
      <header className="bg-white shadow-sm border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-2xl font-bold text-gray-900">
                🛡️ ETH Cannes Privacy Wallet
              </h1>
              <p className="text-gray-600 mt-1">
                Shield and unshield tokens with complete privacy
              </p>
            </div>
            
            <div className="text-right">
              <div className="text-sm text-gray-500">Connected to</div>
              <div className="font-mono text-sm text-gray-900">
                {userAddress?.slice(0, 6)}...{userAddress?.slice(-4)}
              </div>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        
        {/* Factory Stats */}
        <div className="bg-white rounded-lg p-6 mb-8 shadow-sm border border-gray-200">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">
            SodaLabs Private Token Factory
          </h2>
          
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="text-center">
              <div className="text-2xl font-bold text-blue-600">
                {isLoadingTotal ? "..." : totalTokens}
              </div>
              <div className="text-sm text-gray-500">Tokens Created</div>
            </div>
            
            <div className="text-center">
              <div className="text-sm font-mono text-gray-600">
                {factoryAddress?.slice(0, 8)}...{factoryAddress?.slice(-6)}
              </div>
              <div className="text-sm text-gray-500">Factory Address</div>
            </div>
            
            <div className="text-center">
              <div className="text-sm font-semibold text-green-600">
                Base Sepolia
              </div>
              <div className="text-sm text-gray-500">Network</div>
            </div>
          </div>
        </div>

        {/* Token Pair Selection */}
        <div className="bg-white rounded-lg p-6 mb-8 shadow-sm border border-gray-200">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">
            Select Token Pair
          </h2>
          
          <div className="text-center text-gray-500">
            <p className="mb-4">
              Token pair selection will be implemented once we have actual token addresses.
            </p>
            <p className="text-sm">
              For now, this demonstrates the UI structure for the shielding interface.
            </p>
          </div>
        </div>

        {/* Token Pair Display */}
        {selectedTokenPair ? (
          <div className="bg-white rounded-lg p-6 mb-8 shadow-sm border border-gray-200">
            <h2 className="text-lg font-semibold text-gray-900 mb-6 text-center">
              Token Pair - {selectedTokenPair.name}
            </h2>
            
            <TokenPairCard
              clearTokenAddress={selectedTokenPair.clear as `0x${string}`}
              privateTokenAddress={selectedTokenPair.private as `0x${string}`}
              tokenName={selectedTokenPair.name}
              tokenSymbol={selectedTokenPair.symbol}
            />
          </div>
        ) : (
          <div className="bg-white rounded-lg p-6 mb-8 shadow-sm border border-gray-200">
            <h2 className="text-lg font-semibold text-gray-900 mb-6 text-center">
              Token Pair Preview
            </h2>
            
            {/* Demo TokenPairCard with placeholder addresses */}
            <TokenPairCard
              clearTokenAddress={EXAMPLE_CLEAR_TOKEN}
              privateTokenAddress={EXAMPLE_PRIVATE_TOKEN}
              tokenName="Demo Token"
              tokenSymbol="DEMO"
            />
            
            <div className="text-center mt-4 text-sm text-gray-500">
              This is a preview with placeholder addresses. Connect to actual tokens to see real balances.
            </div>
          </div>
        )}

        {/* Operations Panel Placeholder */}
        <div className="bg-gray-50 rounded-lg p-8 shadow-sm border border-gray-200">
          <h2 className="text-lg font-semibold text-gray-900 mb-4 text-center">
            Shielding Operations
          </h2>
          
          <div className="text-center text-gray-500">
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
              <div className="bg-white p-4 rounded-lg border border-gray-200">
                <div className="text-blue-600 text-2xl mb-2">🛡️</div>
                <div className="font-semibold">Shield</div>
                <div className="text-sm text-gray-500">Convert clear to private</div>
              </div>
              
              <div className="bg-white p-4 rounded-lg border border-gray-200">
                <div className="text-green-600 text-2xl mb-2">🔓</div>
                <div className="font-semibold">Unshield</div>
                <div className="text-sm text-gray-500">Convert private to clear</div>
              </div>
              
              <div className="bg-white p-4 rounded-lg border border-gray-200">
                <div className="text-purple-600 text-2xl mb-2">📤</div>
                <div className="font-semibold">Transfer</div>
                <div className="text-sm text-gray-500">Send private tokens</div>
              </div>
            </div>
            
            <p className="text-sm">
              Operation panels will be implemented in the next phase.
            </p>
          </div>
        </div>
      </main>
    </div>
  );
};

export default ShieldingPage;