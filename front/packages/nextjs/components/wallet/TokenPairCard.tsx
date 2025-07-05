import React from "react";
import { ethers } from "ethers";
import { getNetworkDisplayInfo } from "../../config/network";
import { formatPrivateBalance, getUserKeyFromStorage } from "../../utils/soda/cryptoUtils";
import { TokenPair } from "../../hooks/mpc";
import { BottomPanelType } from "./ActionPanel";

interface TokenPairCardProps {
  pair: TokenPair;
  index: number;
  testUsdPrice: number;
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
  onOnboard: () => void;
}

export const TokenPairCard: React.FC<TokenPairCardProps> = ({
  pair,
  index,
  testUsdPrice,
  chainId,
  bottomPanelType,
  activeRowIndex,
  activeNetworkId,
  isRefreshingBalance,
  clickedButton,
  onNetworkSwitch,
  onSetBottomPanel,
  onPrivateBalanceDecrypt,
  onOnboard,
}) => {
  const networkInfo = getNetworkDisplayInfo(pair.chainId);

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
        className={`w-8 h-8 rounded-full flex items-center justify-center transition-colors ${
          isActive
            ? "bg-soda-blue-200 border-2 border-soda-blue-600"
            : pair.chainId === chainId
            ? "bg-gray-100 hover:bg-gray-200"
            : "bg-gray-200 hover:bg-gray-300 text-gray-600"
        }`}
        onClick={onClick}
        disabled={disabled || isLoading}
        title={pair.chainId === chainId ? title : `Switch to ${networkInfo?.name} to ${title}`}
      >
        {isLoading ? (
          <span className="loading loading-spinner loading-xs"></span>
        ) : (
          icon
        )}
      </button>
    );
  };

  return (
    <div className="flex flex-col md:flex-row items-stretch gap-4 mb-4">
      {/* Clear Token Card */}
      <div className="flex flex-col gap-4 p-4 hover:bg-gray-50 rounded-xl transition-colors border border-gray-200 flex-1 min-w-0">
        {/* Metadata */}
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-full bg-soda-blue-900 flex items-center justify-center flex-shrink-0">
            <span className="text-white font-bold text-sm">
              {pair.data.clearTokenSymbol?.charAt(0) ?? "T"}
            </span>
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
            $
            {pair.clearTokenBalance &&
            pair.data.clearTokenDecimals !== null &&
            !isNaN(Number(pair.clearTokenBalance))
              ? (
                  parseFloat(
                    ethers.formatUnits(
                      pair.clearTokenBalance,
                      pair.data.clearTokenDecimals,
                    ),
                  ) * testUsdPrice
                ).toFixed(2)
              : "0.00"}
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
        <div className="flex gap-2 mt-auto">
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
          <div className="w-10 h-10 rounded-full bg-gray-600 flex items-center justify-center flex-shrink-0">
            <span className="text-white font-bold text-sm">
              {pair.data.privateTokenSymbol?.charAt(0) ?? "P"}
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
            {!getUserKeyFromStorage() ||
            !pair.privateTokenBalance ||
            pair.chainId !== chainId
              ? "*****"
              : pair.privateTokenBalance && pair.data.privateTokenDecimals !== null
              ? "$" +
                (
                  parseFloat(
                    formatPrivateBalance(
                      pair.privateTokenBalance,
                      pair.data.privateTokenDecimals,
                    ),
                  ) * testUsdPrice
                ).toFixed(2)
              : "$0.00"}
          </div>
          <div className="text-sm text-gray-500">
            {!getUserKeyFromStorage() ||
            !pair.privateTokenBalance ||
            pair.chainId !== chainId
              ? "*****"
              : pair.data.privateTokenDecimals !== null
              ? formatPrivateBalance(
                  pair.privateTokenBalance,
                  pair.data.privateTokenDecimals,
                )
              : "*****"}{" "}
            {pair.data.privateTokenSymbol ?? "Token"}
          </div>
        </div>

        {/* Actions */}
        {!getUserKeyFromStorage() ? (
          <button
            className="px-3 py-1 bg-soda-blue-900 text-white rounded-full hover:bg-soda-blue-800 transition-colors text-sm mt-auto"
            onClick={onOnboard}
          >
            Onboard
          </button>
        ) : (
          <div className="flex gap-2 mt-auto">
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

            <ActionButton
              action="decrypt"
              title="Decrypt balance"
              onClick={() => {
                if (pair.chainId !== chainId) {
                  onNetworkSwitch(pair.chainId, "decrypt", index);
                } else {
                  onPrivateBalanceDecrypt(pair.chainId, pair.privateAddress);
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
                    d="M2.036 12.322a1.012 1.012 0 010-.639C3.423 7.51 7.36 4.5 12 4.5c4.638 0 8.573 3.007 9.963 7.178.07.207.07.431 0 .639C20.577 16.49 16.64 19.5 12 19.5c-4.638 0-8.573-3.007-9.963-7.178z"
                  />
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
                  />
                </svg>
              }
            />
          </div>
        )}
      </div>
    </div>
  );
}; 