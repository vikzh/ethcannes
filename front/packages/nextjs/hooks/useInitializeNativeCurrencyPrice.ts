import { useCallback, useEffect } from "react";
import { useTargetNetwork } from "./useTargetNetwork";
import { useInterval } from "usehooks-ts";
import scaffoldConfig from "~~/scaffold.config";
import { useGlobalState } from "~~/services/store/store";
import { fetchPriceFromUniswap } from "~~/utils/scaffold-eth";

const enablePolling = false;

// Custom test networks that don't need real price fetching
const TEST_NETWORKS = [84532]; // Base Sepolia

/**
 * Get the price of Native Currency based on Native Token/DAI trading pair from Uniswap SDK
 * For test networks, uses a fixed test price instead of fetching from Uniswap
 */
export const useInitializeNativeCurrencyPrice = () => {
  const setNativeCurrencyPrice = useGlobalState(state => state.setNativeCurrencyPrice);
  const setIsNativeCurrencyFetching = useGlobalState(state => state.setIsNativeCurrencyFetching);
  const { targetNetwork } = useTargetNetwork();

  const fetchPrice = useCallback(async () => {
    setIsNativeCurrencyFetching(true);
    
    // For test networks, use a fixed test price instead of fetching from Uniswap
    if (TEST_NETWORKS.includes(targetNetwork.id)) {
      setNativeCurrencyPrice(1.0); // Fixed $1.00 for test tokens
      setIsNativeCurrencyFetching(false);
      return;
    }
    
    // For other networks, fetch real price from Uniswap (if API key is available)
    try {
      const price = await fetchPriceFromUniswap(targetNetwork);
      setNativeCurrencyPrice(price);
    } catch (error) {
      setNativeCurrencyPrice(0); // Fallback price
    }
    
    setIsNativeCurrencyFetching(false);
  }, [setIsNativeCurrencyFetching, setNativeCurrencyPrice, targetNetwork]);

  // Get the price on mount
  useEffect(() => {
    fetchPrice();
  }, [fetchPrice]);

  // Get the price at intervals (disabled by default)
  useInterval(fetchPrice, enablePolling ? scaffoldConfig.pollingInterval : null);
};
