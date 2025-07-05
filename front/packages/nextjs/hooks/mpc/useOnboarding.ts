import { useState } from "react";
import { ethers } from "ethers";
import { completeOnboarding } from "../../utils/enc/cryptoUtils";
import { notification } from "~~/utils/scaffold-eth";

export const useOnboarding = () => {
  const [isOnboarding, setIsOnboarding] = useState(false);
  const [onboardError, setOnboardError] = useState<string | undefined>(undefined);

  const handleOnboard = async (address: string | undefined) => {
    setIsOnboarding(true);
    setOnboardError(undefined);
    let notificationId;
    
    try {
      if (!window.ethereum || !address) throw new Error("Wallet not connected");
      const provider = new ethers.BrowserProvider(window.ethereum);
      const signer = await provider.getSigner();

      notificationId = notification.loading("Calling onboarding service");
      
      // Complete onboarding process
      await completeOnboarding(signer);

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
  };
}; 