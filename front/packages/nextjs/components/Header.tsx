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
      <RainbowKitCustomConnectButton />
    </div>
  );
};
