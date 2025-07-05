import { useState } from "react";
import { useAccount, useConfig } from "wagmi";
import { completeOnboarding } from "../utils/enc/utils";
import { notification } from "~~/utils/scaffold-eth";

export const useOnboarding = () => {
  const [isOnboarding, setIsOnboarding] = useState(false);
  const [onboardError, setOnboardError] = useState<string | undefined>(undefined);
  
  const { address } = useAccount();
  const wagmiConfig = useConfig();

  const handleOnboard = async () => {
    setIsOnboarding(true);
    setOnboardError(undefined);
    let notificationId;
    
    try {
      if (!address) throw new Error("Wallet not connected");
      if (!wagmiConfig) throw new Error("Wagmi config not available");

      notificationId = notification.loading("Calling onboarding service");
      
      // Complete onboarding process using wagmi
      await completeOnboarding(address, wagmiConfig);

      if (notificationId) notification.remove(notificationId);
      setIsOnboarding(false);
      notification.success("Onboarding complete!", { icon: "" });
      
    } catch (e: any) {
      console.error("Onboarding error:", e);
      if (notificationId) notification.remove(notificationId);
      setIsOnboarding(false);
      setOnboardError(e?.message || "Onboarding failed");
      notification.error("Onboarding failed", e);
    }
  };

  return {
    handleOnboard,
    isOnboarding,
    onboardError,
    address,
  };
};