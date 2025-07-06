import React from "react";
import { useAccount } from "wagmi";
import { useOnboarding } from "../hooks/mpc/useOnboarding";
import { getUserKeyFromStorage } from "../utils/enc/cryptoUtils";
// @ts-ignore
import UseAnimations from "react-useanimations";
// @ts-ignore
import loading from "react-useanimations/lib/loading";

/**
 * Top-of-page banner that prompts the user to complete MPC onboarding if they
 * haven't generated & uploaded their encryption key yet.
 */
const OnboardBanner: React.FC = () => {
  const { address } = useAccount();
  const hasKey = typeof window !== "undefined" && getUserKeyFromStorage();
  const { handleOnboard, isOnboarding } = useOnboarding();

  if (hasKey) return null; // already onboarded – nothing to show

  const onClick = () => {
    if (!isOnboarding) {
      handleOnboard(address);
    }
  };

  return (
    <div className="w-full bg-soda-blue-50 border border-soda-blue-200 text-soda-blue-900 rounded-xl px-4 py-3 mb-6 flex items-center justify-between" role="alert">
      <p className="text-sm font-medium">
        To send or reveal amounts for shielded tokens you must first onboard to the MPC service.
      </p>
      <button
        onClick={onClick}
        disabled={isOnboarding}
        className="min-w-[160px] flex justify-center items-center gap-1 px-6 py-2 rounded-full text-sm font-medium transition-colors disabled:opacity-60 disabled:cursor-default bg-soda-blue-900 text-white hover:bg-soda-blue-800"
      >
        {isOnboarding ? <UseAnimations animation={loading} size={20} strokeColor="#fff" /> : "Onboard"}
      </button>
    </div>
  );
};

export default OnboardBanner; 