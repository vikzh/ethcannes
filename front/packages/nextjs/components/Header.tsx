"use client";

import React from "react";
import { RainbowKitCustomConnectButton } from "~~/components/scaffold-eth";
import { useAccount } from "wagmi";
import { getUserKeyFromStorage } from "../utils/enc/cryptoUtils";
import { useOnboarding } from "../hooks/mpc/useOnboarding";
// @ts-ignore - no type definitions for this lib
import UseAnimations from "react-useanimations";
// @ts-ignore - no type definitions for this lib
import loading from "react-useanimations/lib/loading";

/**
 * Site header - now only contains wallet connection
 */
export const Header = () => {
  const { address, isConnected } = useAccount();
  const { handleOnboard, isOnboarding } = useOnboarding();

  const hasKey = typeof window !== "undefined" && getUserKeyFromStorage();

  const handleClick = () => {
    if (!hasKey && !isOnboarding) {
      handleOnboard(address);
    }
  };

  return (
    <div className="flex items-center gap-4">
      {isConnected && (
        <button
          onClick={handleClick}
          disabled={isOnboarding || !!hasKey}
          className={`flex items-center gap-1 px-3 py-1 rounded-full text-sm font-medium transition-colors disabled:opacity-60 disabled:cursor-default
            ${
              isOnboarding
                ? "bg-gray-200 text-gray-600"
                : hasKey
                ? "bg-green-100 text-green-700"
                : "bg-soda-blue-900 text-white hover:bg-soda-blue-800"
            }`}
        >
          {isOnboarding ? (
            <UseAnimations animation={loading} size={20} strokeColor="#0F62FE" />
          ) : hasKey ? (
            "Onboarded"
          ) : (
            "Onboard"
          )}
        </button>
      )}
      <RainbowKitCustomConnectButton />
    </div>
  );
};
