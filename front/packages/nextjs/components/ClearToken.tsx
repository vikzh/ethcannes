"use client";

import { useAccount, useReadContract, useWriteContract } from "wagmi";
import { parseUnits, formatUnits } from "viem";
import { useState } from "react";
import { CLEAR_TOKEN_ABI } from "~~/config/contracts";
import { notification } from "~~/utils/scaffold-eth";
import { EtherInput } from "~~/components/scaffold-eth";

const CLEAR_TOKEN_ADDRESS = "0xac00f90ed73b8a3d8ea4dd3ff9a22d5156a7d60d"; // Replace with your deployed contract address

export const ClearToken = () => {
    const { address } = useAccount();
    const [mintAmount, setMintAmount] = useState("0");
    const symbol = "USDC"; // hardcoded for now — can fetch dynamically if needed
    const decimals = 18; // also hardcoded

    // 🔍 Read token balance
    const { data: balance } = useReadContract({
        address: CLEAR_TOKEN_ADDRESS,
        abi: CLEAR_TOKEN_ABI,
        functionName: "balanceOf",
        args: [address],
    });

    // ✍️ Write mint transaction
    const { writeContract, isPending } = useWriteContract();

    const handleMint = () => {
        if (!address || !mintAmount) return;

        try {
            writeContract(
                {
                    address: CLEAR_TOKEN_ADDRESS,
                    abi: CLEAR_TOKEN_ABI,
                    functionName: "mint",
                    args: [address, parseUnits(mintAmount, decimals)],
                },
                {
                    onSuccess: tx => notification.success(`Mint submitted: ${tx}`),
                    onError: err => notification.error(`Mint failed: ${err.message}`),
                }
            );
        } catch (e: any) {
            notification.error(`Error: ${e.message}`);
        }
    };

    return (
        <div className="max-w-md mx-auto mt-10 space-y-6 p-6 bg-white border border-gray-200 rounded-lg shadow-lg">
            <h2 className="text-2xl font-bold text-center text-gray-800">🪙 ClearToken Dashboard</h2>

            {/* 📈 Balance Section */}
            <div className="space-y-2">
                <h3 className="text-lg font-semibold text-gray-700">Your Balance</h3>
                <p className="text-sm text-gray-600">Connected address:</p>
                <code className="block text-sm break-all text-blue-600">{address}</code>
                <p className="text-xl font-mono mt-2">
                    {balance ? `${formatUnits(balance, decimals)} ${symbol}` : "Loading..."}
                </p>
            </div>

            {/* 🧪 Minting Section */}
            <div className="pt-4 border-t border-gray-200">
                <h3 className="text-lg font-semibold text-gray-700 mb-2">Mint Tokens</h3>

                <EtherInput value={mintAmount} onChange={setMintAmount} placeholder={`Amount in ${symbol}`} />

                <button
                    className="mt-3 w-full py-2 px-4 bg-blue-600 text-white font-semibold rounded hover:bg-blue-700 disabled:opacity-50"
                    onClick={handleMint}
                    disabled={isPending || !mintAmount}
                >
                    {isPending ? "Minting..." : `Mint ${symbol}`}
                </button>
            </div>
        </div>
    );
};
