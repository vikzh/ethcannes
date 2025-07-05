"use client";

import React, { useState } from "react";
import Loading from "./components/Loading";
import PortfolioHeader from "./components/PortfolioHeader";
import TokenPairsList from "./components/TokenPairsList";
import { notification } from "~~/utils/scaffold-eth";
import { useWalletData } from "../../hooks/wallet/useWalletData";
import { getNetworkDisplayInfo } from "../../utils/wallet/networkUI";

const WalletPage = () => {
  const {
    isConnected,
    chainId,
    filteredTokenPairs,
    isLoading,
    isRefreshingBalance,
    updateTokenPairBalance,
    handlePrivateBalanceDecrypt,
    handleOnboardClick,
    onboardError,
    networkTokenData,
  } = useWalletData();

  const [showNetworkModal, setShowNetworkModal] = useState(false);
  const [pendingNetworkSwitch, setPendingNetworkSwitch] = useState<number | null>(null);
  const [isSwitchingNetwork, setIsSwitchingNetwork] = useState(false);
  const [clickedButton, setClickedButton] = useState<{ action: string; networkId: number; index: number } | null>(null);

  const handleNetworkSwitch = (targetChainId: number, action: string, index: number) => {
    setPendingNetworkSwitch(targetChainId);
    setClickedButton({ action, networkId: targetChainId, index });
    setShowNetworkModal(true);
  };

  const confirmNetworkSwitch = async () => {
    if (!pendingNetworkSwitch) return;
    const networkName = getNetworkDisplayInfo(pendingNetworkSwitch).name;
    setIsSwitchingNetwork(true);
    try {
      if (!window.ethereum) {
        notification.error("Please install MetaMask or another Web3 wallet");
        return;
      }
      const chainIdHex = `0x${pendingNetworkSwitch.toString(16)}`;
      await window.ethereum.request({
        method: "wallet_switchEthereumChain",
        params: [{ chainId: chainIdHex }],
      });
      notification.success(`Switched to ${networkName}`);
    } catch (error: any) {
      console.error("Failed to switch network:", error);
      notification.error(`Failed to switch network: ${error.message}`);
    } finally {
      setShowNetworkModal(false);
      setPendingNetworkSwitch(null);
      setIsSwitchingNetwork(false);
    }
  };

  const cancelNetworkSwitch = () => {
    setShowNetworkModal(false);
    setPendingNetworkSwitch(null);
  };

  const [testUsdPrice] = useState(() => 0.98 + Math.random() * 0.03);

  if (isLoading) {
    return <Loading />;
  }

  return (
    <div className="flex flex-col items-center justify-start py-8 px-6">
      <div className="w-full max-w-6xl">
        {isConnected && (
          <>
            <PortfolioHeader />
            <div className="bg-white rounded-3xl shadow-lg p-6 mt-6">
              <TokenPairsList
                chainId={chainId}
                testUsdPrice={testUsdPrice}
                filteredTokenPairs={filteredTokenPairs}
                isRefreshingBalance={isRefreshingBalance}
                clickedButton={clickedButton}
                onNetworkSwitch={handleNetworkSwitch}
                updateTokenPairBalance={updateTokenPairBalance}
                handlePrivateBalanceDecrypt={handlePrivateBalanceDecrypt}
                handleOnboardClick={handleOnboardClick}
                networkTokenData={networkTokenData}
              />
            </div>
          </>
        )}
        {onboardError && <div className="text-red-500 text-center">{onboardError}</div>}
      </div>

    </div>
  );
};

export default WalletPage;

 