import { getNetworkConfig } from "../../config/network";

export const getNetworkDisplayInfo = (chainId: number) => {
  const config = getNetworkConfig(chainId);
  return {
    name: config.CHAIN_NAME,
    shortName: config.SHORT_NAME,
    color: config.COLOR,
    iconUrl: config.ICON_URL,
  } as const;
}; 