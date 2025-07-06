import React from "react";
import { ethers } from "ethers";
import { getNetworkDisplayInfo } from "../../config/network";
import { getUserKeyFromStorage } from "../../utils/enc/cryptoUtils";
import { TokenPair } from "../../hooks/mpc";
import { BottomPanelType } from "./ActionPanel";

interface TokenPairCardProps {
  pair: TokenPair;
  index: number;
  chainId: number;
  
  // Panel state
  bottomPanelType: BottomPanelType;
  activeRowIndex: number | null;
  activeNetworkId: number | null;
  
  // Loading states
  isRefreshingBalance: boolean;
  clickedButton: {action: string, networkId: number, index: number} | null;
  
  // Handlers
  onNetworkSwitch: (targetChainId: number, action: string, index: number) => void;
  onSetBottomPanel: (type: BottomPanelType, index: number, networkId: number) => void;
  onPrivateBalanceDecrypt: (chainId: number, privateTokenAddress?: string) => void;
  onPrivateBalanceClear: (privateTokenAddress: string) => void;
  onOnboard: () => void;
}

// token logo mapping
const TOKEN_LOGOS: Record<string, string> = {
  "0x331dacc9928d783c34b6b0f3961cad4a948155af": "https://etherscan.io/token/images/usdc_ofc_32.svg",
  "0x353f9140fd398ec8ec16d3cc72c7d7db61c93a41": "https://etherscan.io/token/images/weth_28.png?v=2",
};

export const TokenPairCard: React.FC<TokenPairCardProps> = ({
  pair,
  index,
  chainId,
  bottomPanelType,
  activeRowIndex,
  activeNetworkId,
  isRefreshingBalance,
  clickedButton,
  onNetworkSwitch,
  onSetBottomPanel,
  onPrivateBalanceDecrypt,
  onPrivateBalanceClear,
  onOnboard,
}) => {
  const networkInfo = getNetworkDisplayInfo(pair.chainId);

  // Local state to manage visibility of the private token balance
  const [isBalanceHidden, setIsBalanceHidden] = React.useState<boolean>(
    !pair.privateTokenBalance,
  );

  // When a decrypted balance arrives through state updates, automatically reveal it
  React.useEffect(() => {
    if (pair.privateTokenBalance && isBalanceHidden) {
      setIsBalanceHidden(false);
    }
  }, [pair.privateTokenBalance]);

  const handleToggleBalanceVisibility = () => {
    if (isBalanceHidden) {
      // Balance is currently hidden – attempt to reveal
      if (pair.privateTokenBalance) {
        // Already decrypted – just show it
        setIsBalanceHidden(false);
      } else {
        // Need to decrypt first – reuse existing decrypt logic
        if (pair.chainId !== chainId) {
          onNetworkSwitch(pair.chainId, "decrypt", index);
        } else {
          onPrivateBalanceDecrypt(pair.chainId, pair.privateAddress);
        }
      }
    } else {
      // Hide the balance and clear the cached decrypted value so next reveal triggers signature again
      setIsBalanceHidden(true);
      // Inform parent to remove cached balance
      onPrivateBalanceClear(pair.privateAddress);
    }
  };

  // Action button component
  const ActionButton: React.FC<{
    action: string;
    icon: React.ReactNode;
    title: string;
    disabled?: boolean;
    isActive?: boolean;
    onClick: () => void;
  }> = ({ action, icon, title, disabled = false, isActive = false, onClick }) => {

    const isLoading = 
      (action === "decrypt" && (isRefreshingBalance && pair.chainId === chainId)) ||
      (clickedButton?.action === action && clickedButton?.networkId === pair.chainId && clickedButton?.index === index);

    return (
      <button
        className={`flex items-center gap-1 md:gap-2 text-xs md:text-sm font-medium rounded-full px-2.5 md:px-3 py-1 transition-colors focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-soda-blue-600
          ${isActive
            ? "bg-soda-blue-600 text-white"
            : pair.chainId === chainId
            ? "bg-gray-100 hover:bg-gray-200 text-gray-800"
            : "bg-gray-200 hover:bg-gray-300 text-gray-600"}
          ${disabled || isLoading ? "opacity-60 cursor-not-allowed" : ""}`}
        onClick={onClick}
        disabled={disabled || isLoading}
        title={pair.chainId === chainId ? title : `Switch to ${networkInfo?.name} to ${title}`}
      >
        {isLoading ? (
          <span className="loading loading-spinner loading-xs"></span>
        ) : (
          icon
        )}
        {/* Show label on medium+ screens to keep compact on mobile */}
        <span className="hidden md:inline-block whitespace-nowrap">{title}</span>
      </button>
    );
  };

  const [isOnboarded, setIsOnboarded] = React.useState<boolean>(() => !!getUserKeyFromStorage());

  React.useEffect(() => {
    const handler = () => setIsOnboarded(!!getUserKeyFromStorage());
    window.addEventListener("onboarded", handler);
    return () => window.removeEventListener("onboarded", handler);
  }, []);

  return (
    <div className="flex flex-col md:flex-row items-stretch gap-4 mb-4">
      {/* Clear Token Card */}
      <div className="flex flex-col gap-4 p-4 hover:bg-gray-50 rounded-xl transition-colors border border-gray-200 flex-1 min-w-0">
        {/* Metadata */}
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-full bg-soda-blue-900 flex items-center justify-center flex-shrink-0 overflow-hidden">
            {TOKEN_LOGOS[pair.clearAddress.toLowerCase()] ? (
              <img src={TOKEN_LOGOS[pair.clearAddress.toLowerCase()]} alt={pair.data.clearTokenSymbol ?? "token"} className="w-full h-full object-contain" />
            ) : (
              <span className="text-white font-bold text-sm">
                {pair.data.clearTokenSymbol?.charAt(0) ?? "T"}
              </span>
            )}
          </div>
          <div>
            <div className="font-semibold text-gray-900">
              {pair.data.clearTokenName ?? "Loading..."}
            </div>
            <div className="text-sm text-gray-500">
              {pair.data.clearTokenSymbol ?? "Loading..."}
            </div>
          </div>
        </div>

        {/* Balance */}
        <div>
          <div className="font-semibold text-gray-900">
            {(() => {
              if (
                pair.clearTokenBalance &&
                pair.data.clearTokenDecimals !== null &&
                !isNaN(Number(pair.clearTokenBalance))
              ) {
                const amount = parseFloat(
                  ethers.formatUnits(pair.clearTokenBalance, pair.data.clearTokenDecimals),
                );
                const usd = amount * (pair.data.baseRate ?? 1);
                return "$" + usd.toFixed(2);
              }
              return "$0.00";
            })()}
          </div>
          <div className="text-sm text-gray-500">
            {pair.clearTokenBalance &&
            pair.data.clearTokenDecimals !== null &&
            !isNaN(Number(pair.clearTokenBalance))
              ? ethers.formatUnits(pair.clearTokenBalance, pair.data.clearTokenDecimals)
              : "0.0"}{" "}
            {pair.data.clearTokenSymbol ?? "Token"}
          </div>
        </div>

        {/* Actions */}
        <div className="flex flex-wrap gap-2 mt-auto">
          <ActionButton
            action="transfer-clear"
            title="Send"
            disabled={!pair.clearTokenBalance || pair.clearTokenBalance === "0"}
            isActive={
              bottomPanelType === "transfer-clear" &&
              activeRowIndex === index &&
              activeNetworkId === pair.chainId
            }
            onClick={() => {
              if (pair.chainId !== chainId) {
                onNetworkSwitch(pair.chainId, "transfer-clear", index);
              } else {
                onSetBottomPanel("transfer-clear", index, pair.chainId);
              }
            }}
            icon={
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                strokeWidth={1.5}
                stroke="currentColor"
                className="w-3.5 h-3.5"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  d="M4.5 19.5l15-15m0 0H8.25m11.25 0v11.25"
                />
              </svg>
            }
          />
          <ActionButton
            action="shield"
            title="Shield"
            disabled={!pair.clearTokenBalance || pair.clearTokenBalance === "0"}
            isActive={
              bottomPanelType === "shield" &&
              activeRowIndex === index &&
              activeNetworkId === pair.chainId
            }
            onClick={() => {
              if (pair.chainId !== chainId) {
                onNetworkSwitch(pair.chainId, "shield", index);
              } else {
                onSetBottomPanel("shield", index, pair.chainId);
              }
            }}
            icon={
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                strokeWidth={1.5}
                stroke="currentColor"
                className="w-4 h-4"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  d="M9 12.75L11.25 15 15 9.75m-3-7.036A11.959 11.959 0 013.598 6 11.99 11.99 0 003 9.749c0 5.592 3.824 10.29 9 11.623 5.176-1.332 9-6.03 9-11.623 0-1.31-.21-2.571-.598-3.751h-.152c-3.196 0-6.1-1.248-8.25-3.285z"
                />
              </svg>
            }
          />
          <ActionButton
            action="mint"
            title="Mint"
            isActive={
              bottomPanelType === "mint" &&
              activeRowIndex === index &&
              activeNetworkId === pair.chainId
            }
            onClick={() => {
              if (pair.chainId !== chainId) {
                onNetworkSwitch(pair.chainId, "mint", index);
              } else {
                onSetBottomPanel("mint", index, pair.chainId);
              }
            }}
            icon={
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                strokeWidth={1.5}
                stroke="currentColor"
                className="w-4 h-4"
              >
                <path strokeLinecap="round" strokeLinejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
              </svg>
            }
          />
        </div>
      </div>

      {/* Swap Icon */}
      <div className="hidden md:flex items-center justify-center">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          strokeWidth={1.5}
          stroke="currentColor"
          className="w-6 h-6 text-gray-400"
        >
          <path
            strokeLinecap="round"
            strokeLinejoin="round"
            d="M8 7h13M21 7l-3-3M21 7l-3 3M8 17h13M8 17l3-3M8 17l3 3"
          />
        </svg>
      </div>

      {/* Private Token Card */}
      <div className="flex flex-col gap-4 p-4 hover:bg-gray-50 rounded-xl transition-colors border border-gray-200 flex-1 min-w-0">
        {/* Metadata */}
        <div className="flex items-center gap-3">
          <div className="relative w-10 h-10 rounded-full bg-gray-600 flex items-center justify-center flex-shrink-0">
            {TOKEN_LOGOS[pair.clearAddress.toLowerCase()] ? (
              <img src={TOKEN_LOGOS[pair.clearAddress.toLowerCase()]} alt={pair.data.privateTokenSymbol ?? "token"} className="w-full h-full object-contain" />
            ) : (
              <span className="text-white font-bold text-sm">
                {pair.data.privateTokenSymbol?.charAt(0) ?? "P"}
              </span>
            )}
            {/* small shield badge */}
            <span className="absolute -bottom-1 -right-1 bg-soda-blue-600 p-1 rounded-full">
            <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                strokeWidth={1.5}
                stroke="white"
                className="w-4 h-4"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  d="M9 12.75L11.25 15 15 9.75m-3-7.036A11.959 11.959 0 013.598 6 11.99 11.99 0 003 9.749c0 5.592 3.824 10.29 9 11.623 5.176-1.332 9-6.03 9-11.623 0-1.31-.21-2.571-.598-3.751h-.152c-3.196 0-6.1-1.248-8.25-3.285z"
                />
              </svg>
            </span>
          </div>
          <div>
            <div className="font-semibold text-gray-900">
              {pair.data.privateTokenName ?? "Loading..."}
            </div>
            <div className="text-sm text-gray-500">
              {pair.data.privateTokenSymbol ?? "Loading..."}
            </div>
          </div>
        </div>

        {/* Balance */}
        <div>
          <div className="font-semibold text-gray-900">
            {isBalanceHidden || !getUserKeyFromStorage() || pair.chainId !== chainId
              ? "*****"
              : pair.privateTokenBalance && pair.data.privateTokenDecimals !== null
              ? "$" +
                (() => {
                  const amount = parseFloat(
                    ethers.formatUnits(
                      pair.privateTokenBalance,
                      pair.data.privateTokenDecimals,
                    ),
                  );
                  return amount.toFixed(2);
                })()
              : "0.00"}
          </div>
          <div className="text-sm text-gray-500 flex items-center gap-2">
            <span>
              {isBalanceHidden || !getUserKeyFromStorage() || pair.chainId !== chainId
                ? "*****"
                : pair.data.privateTokenDecimals !== null && pair.privateTokenBalance
                ? (() => {
                    const amount = parseFloat(
                      ethers.formatUnits(
                        pair.privateTokenBalance,
                        pair.data.privateTokenDecimals,
                      ),
                    );
                    return amount.toFixed(2);
                  })()
                : "*****"}
            </span>
            {/* Toggle visibility button – always rendered */}
            <button
              type="button"
              className="w-5 h-5 flex items-center justify-center hover:text-gray-700 transition-colors disabled:opacity-50"
              onClick={handleToggleBalanceVisibility}
              disabled={!getUserKeyFromStorage() || (isRefreshingBalance && pair.chainId === chainId)}
              title={getUserKeyFromStorage() ? undefined : "Onboard first to reveal"}
            >
              {isRefreshingBalance && pair.chainId === chainId ? (
                <span className="loading loading-spinner loading-xs"></span>
              ) : isBalanceHidden ? (
                // Eye (show)
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  strokeWidth={1.5}
                  stroke="currentColor"
                  className="w-4 h-4"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    d="M2.036 12.322a1.012 1.012 0 010-.639C3.423 7.51 7.36 4.5 12 4.5c4.638 0 8.573 3.007 9.963 7.178.07.207.07.431 0 .639C20.577 16.49 16.64 19.5 12 19.5c-4.638 0-8.573-3.007-9.963-7.178z"
                  />
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
                  />
                </svg>
              ) : (
                // Eye with slash (hide)
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  strokeWidth={1.5}
                  stroke="currentColor"
                  className="w-4 h-4"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    d="M3.98 8.223a10.477 10.477 0 00-1.514 3.777 1.012 1.012 0 000 .001C3.423 16.49 7.36 19.5 12 19.5c2.18 0 4.208-.67 5.874-1.816m2.106-2.106A10.476 10.476 0 0021 12.001v-.002M6.343 6.343A10.46 10.46 0 0112 4.5c4.638 0 8.573 3.007 9.963 7.178a1.012 1.012 0 010 .639m-6.6 2.14a3 3 0 01-4.244-4.244"
                  />
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    d="M3 3l18 18"
                  />
                </svg>
              )}
            </button>
            <span>{pair.data.privateTokenSymbol ?? "Token"}</span>
          </div>
        </div>

        {/* Actions */}
        <div className="flex flex-wrap gap-2 mt-auto">
          <ActionButton
            action="transfer-private"
            title="Send"
            isActive={
              bottomPanelType === "transfer-private" &&
              activeRowIndex === index &&
              activeNetworkId === pair.chainId
            }
            onClick={() => {
              if (pair.chainId !== chainId) {
                onNetworkSwitch(pair.chainId, "transfer-private", index);
              } else {
                onSetBottomPanel("transfer-private", index, pair.chainId);
              }
            }}
            icon={
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                strokeWidth={1.5}
                stroke="currentColor"
                className="w-3.5 h-3.5"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  d="M4.5 19.5l15-15m0 0H8.25m11.25 0v11.25"
                />
              </svg>
            }
            disabled={!getUserKeyFromStorage()}
          />

          <ActionButton
            action="unshield"
            title="Unshield"
            isActive={
              bottomPanelType === "unshield" &&
              activeRowIndex === index &&
              activeNetworkId === pair.chainId
            }
            onClick={() => {
              if (pair.chainId !== chainId) {
                onNetworkSwitch(pair.chainId, "unshield", index);
              } else {
                onSetBottomPanel("unshield", index, pair.chainId);
              }
            }}
            icon={
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                strokeWidth={1.5}
                stroke="currentColor"
                className="w-4 h-4"
              >
                {/* Shield outline - same as shield icon but without checkmark */}
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  d="M12 1.464A11.959 11.959 0 013.598 6 11.99 11.99 0 003 9.749c0 5.592 3.824 10.29 9 11.623 5.176-1.332 9-6.03 9-11.623 0-1.31-.21-2.571-.598-3.751h-.152c-3.196 0-6.1-1.248-8.25-3.285z"
                />
                {/* Diagonal slash */}
                <path strokeLinecap="round" strokeLinejoin="round" d="m6 6 12 12" />
              </svg>
            }
          />
        </div>
      </div>
    </div>
  );
}; 