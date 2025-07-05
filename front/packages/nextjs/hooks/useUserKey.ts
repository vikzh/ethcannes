import { useState, useEffect, useCallback } from "react";
import { useAccount } from "wagmi";
import { getUserKey, storeUserKey } from "../utils/enc/utils";

/**
 * Reactively exposes the AES key bound to the currently connected address.
 * Falls back to undefined when the wallet disconnects or no key is present.
 */
export const useUserKey = () => {
  const { address } = useAccount();
  const [aesKey, setAesKey] = useState<string | null>(null);

  // Load key from localStorage whenever address changes
  useEffect(() => {
    if (address) {
      setAesKey(getUserKey(address));
    } else {
      setAesKey(null);
    }
  }, [address]);

  /** Store a new key for the current address and update state */
  const saveKey = useCallback(
    (key: string) => {
      if (!address) return;
      storeUserKey(key, address);
      setAesKey(key);
    },
    [address],
  );

  /** Clears the stored key for the current address */
  const clearKey = useCallback(() => {
    if (!address) return;
    localStorage.removeItem(`aesKey_${address.toLowerCase()}`);
    setAesKey(null);
  }, [address]);

  return { aesKey, hasKey: !!aesKey, saveKey, clearKey, address };
};

export default useUserKey; 