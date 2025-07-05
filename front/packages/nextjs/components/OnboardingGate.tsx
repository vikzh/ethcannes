"use client";

import React from "react";
import useRequireOnboarding from "../hooks/useRequireOnboarding";

const Overlay: React.FC<{ children: React.ReactNode }> = ({ children }) => (
  <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm">
    <div className="bg-white dark:bg-gray-900 p-8 rounded-xl shadow-xl max-w-md w-full text-center">
      {children}
    </div>
  </div>
);

export const OnboardingGate: React.FC = () => {
  const { requiresOnboarding, triggerOnboarding, isOnboarding, onboardError } = useRequireOnboarding();

  if (!requiresOnboarding) return null;

  return (
    <Overlay>
      <h2 className="text-xl font-semibold mb-4">Private-wallet Onboarding Required</h2>
      <p className="text-sm text-gray-600 dark:text-gray-300 mb-6">
        We need to generate and securely store your encryption key so you can use private balances and other features. This
        process requires one signature approval in your wallet.
      </p>

      {onboardError && (
        <div className="mb-4 text-sm text-red-500 dark:text-red-400">{onboardError}</div>
      )}

      <button
        onClick={triggerOnboarding}
        disabled={isOnboarding}
        className="px-4 py-2 rounded-md bg-blue-600 disabled:bg-blue-400 text-white font-medium"
      >
        {isOnboarding ? "Processing…" : "Start Onboarding"}
      </button>
    </Overlay>
  );
};

export default OnboardingGate; 