import { useMemo } from "react";
import { useOnboarding } from "./useOnboarding";
import { useUserKey } from "./useUserKey";
import { useAccount } from "wagmi";

/**
 * Provides a simple API for gating the app behind onboarding.
 */
export const useRequireOnboarding = () => {
  const { hasKey } = useUserKey();
  const { handleOnboard, isOnboarding, onboardError } = useOnboarding();
  const { address } = useAccount();

  // Onboarding is required if a wallet is connected but no AES key exists yet.
  const requiresOnboarding = useMemo(() => {
    return !!address && !hasKey;
  }, [address, hasKey]);

  return {
    requiresOnboarding,
    triggerOnboarding: handleOnboard,
    isOnboarding,
    onboardError,
  };
};

export default useRequireOnboarding; 