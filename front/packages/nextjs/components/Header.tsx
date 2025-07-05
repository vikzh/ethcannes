"use client";

import React from "react";
import { RainbowKitCustomConnectButton } from "~~/components/scaffold-eth";

/**
 * Site header - now only contains wallet connection
 */
export const Header = () => {
  return (
    <div className="flex items-center">
      <RainbowKitCustomConnectButton />
    </div>
  );
};
