import { useState } from "react";
import { ethers } from "ethers";
import { useAccount } from "wagmi";
import { TokenPair } from "../mpc";
import { CLEAR_TOKEN_ABI, PRIVATE_TOKEN_ABI } from "../../config/contracts";
import { prepareMessageForBubble } from "../../utils/enc/signMessage";
import { getUserKeyFromStorage } from "../../utils/enc/cryptoUtils";
import { BlockchainService } from "../../services/wallet";
import { notification } from "~~/utils/scaffold-eth";

export const useWalletActions = (
  updateTokenPairBalance: (privateAddress: string, updates: Partial<any>) => void,
  _updateNetworkData: (chainId: number) => void, // reserved for future use
) => {
  const { address } = useAccount();

  const [approvingTokens, setApprovingTokens] = useState<Set<string>>(new Set());
  const [isTransferring, setIsTransferring] = useState(false);
  const [isShielding, setIsShielding] = useState(false);
  const [isUnshielding, setIsUnshielding] = useState(false);
  const [isMinting, setIsMinting] = useState(false);
  const [shieldError, setShieldError] = useState<string | undefined>(undefined);
  const tokenAllowances: Record<string, string> = {};

  const handleApprove = async (tokenPair: TokenPair) => {
    if (!address) return;
    setApprovingTokens(prev => new Set(prev).add(tokenPair.privateAddress));
    try {
      const provider = new ethers.BrowserProvider(window.ethereum);
      const signer = await provider.getSigner();
      const contract = new ethers.Contract(tokenPair.clearAddress, CLEAR_TOKEN_ABI, signer);
      const maxUint256 = BigInt("115792089237316195423570985008687907853269984665640564039457584007913129639935");
      const tx = await contract.approve(tokenPair.privateAddress, maxUint256);
      await tx.wait();
      const newAllowance = await contract.allowance(address, tokenPair.privateAddress);
      tokenAllowances[tokenPair.privateAddress] = newAllowance.toString();
      setShieldError(undefined);
      notification.success(`Approval successful for ${tokenPair.data.clearTokenSymbol}!`);
    } catch (err: any) {
      console.error("Approval error:", err);
      notification.error("Failed to approve tokens");
    } finally {
      setApprovingTokens(prev => {
        const next = new Set(prev);
        next.delete(tokenPair.privateAddress);
        return next;
      });
    }
  };

  const transferClear = async (tokenPair: TokenPair, amount: string, recipient: string) => {
    if (!amount || !recipient || !address) return;
    setIsTransferring(true);
    try {
      const provider = new ethers.BrowserProvider(window.ethereum);
      const signer = await provider.getSigner();
      const contract = new ethers.Contract(tokenPair.clearAddress, CLEAR_TOKEN_ABI, signer);
      const amountInDecimals = ethers.parseUnits(amount, tokenPair.data.clearTokenDecimals || 18);
      const currentBalance = await contract.balanceOf(address);
      if (BigInt(currentBalance) < BigInt(amountInDecimals)) throw new Error("Insufficient balance");
      if (!ethers.isAddress(recipient)) throw new Error("Invalid recipient address");
      const tx = await contract.transfer(recipient, amountInDecimals);
      await tx.wait();
      notification.success("Send successful!");
      const newBalance = await contract.balanceOf(address);
      updateTokenPairBalance(tokenPair.privateAddress, { clearTokenBalance: newBalance.toString() });
    } catch (err: any) {
      console.error("Send error:", err);
      notification.error("Send failed: " + (err.message || "Unknown error"));
    } finally {
      setIsTransferring(false);
    }
  };

  const transferPrivate = async (tokenPair: TokenPair, amount: string, recipient: string) => {
    if (!amount || !recipient || !address) return;
    setIsTransferring(true);
    try {
      const provider = new ethers.BrowserProvider(window.ethereum);
      const signer = await provider.getSigner();
      const contract = new ethers.Contract(tokenPair.privateAddress, PRIVATE_TOKEN_ABI, signer);
      const amountInDecimals = ethers.parseUnits(amount, tokenPair.data.privateTokenDecimals || 5);
      const { encryptedInt, messageBytes } = prepareMessageForBubble(
        amountInDecimals,
        address,
        getUserKeyFromStorage() as string,
        tokenPair.privateAddress,
      );
      const signedMessage = await signer.signMessage(messageBytes);
      const tx = await contract["transfer(address,(uint256,bytes))"](recipient, {
        ciphertext: encryptedInt,
        signature: signedMessage,
      });
      await tx.wait();
      notification.success("Send successful!");
    } catch (err: any) {
      console.error("Send error:", err);
      notification.error("Send failed: " + (err.message || "Unknown error"));
    } finally {
      setIsTransferring(false);
    }
  };

  const shield = async (tokenPair: TokenPair, amount: string) => {
    if (!amount || !address) return;
    setIsShielding(true);
    setShieldError(undefined);
    try {
      const provider = new ethers.BrowserProvider(window.ethereum);
      const signer = await provider.getSigner();
      const clearTokenDecimals = tokenPair.data.clearTokenDecimals || 18;
      const amountToShield = ethers.parseUnits(amount, clearTokenDecimals);
      const clearContract = new ethers.Contract(tokenPair.clearAddress, CLEAR_TOKEN_ABI, provider);
      const currentBalance = await clearContract.balanceOf(address);
      if (BigInt(currentBalance) < BigInt(amountToShield)) {
        setShieldError(`Insufficient balance. You only have ${ethers.formatUnits(currentBalance, clearTokenDecimals)} ${tokenPair.data.clearTokenSymbol}.`);
        return;
      }
      let currentAllowance = tokenAllowances[tokenPair.privateAddress];
      if (!currentAllowance) {
        const allowance = await clearContract.allowance(address, tokenPair.privateAddress);
        currentAllowance = allowance.toString();
        tokenAllowances[tokenPair.privateAddress] = currentAllowance;
      }
      if (BigInt(currentAllowance) < BigInt(amountToShield)) {
        setShieldError(`Insufficient allowance. Please approve ${tokenPair.data.clearTokenSymbol} tokens first.`);
        return;
      }
      const privateContract = new ethers.Contract(tokenPair.privateAddress, PRIVATE_TOKEN_ABI, signer);
      const tx = await privateContract.shield(amountToShield);
      await tx.wait();
      notification.success("Shield successful!");
      const newClearBalance = await clearContract.balanceOf(address);
      updateTokenPairBalance(tokenPair.privateAddress, { clearTokenBalance: newClearBalance.toString() });
    } catch (err: any) {
      console.error("Shield error:", err);
      setShieldError(err?.message || "Failed to shield tokens");
      notification.error("Failed to shield tokens");
    } finally {
      setIsShielding(false);
    }
  };

  const unshield = async (tokenPair: TokenPair, amount: string) => {
    if (!amount || !address) return;
    setIsUnshielding(true);
    setShieldError(undefined);
    try {
      const provider = new ethers.BrowserProvider(window.ethereum);
      const signer = await provider.getSigner();
      const privateContract = new ethers.Contract(tokenPair.privateAddress, PRIVATE_TOKEN_ABI, signer);
      const privateDecimals = tokenPair.data.privateTokenDecimals ?? 5;
      const amountToUnshield = ethers.parseUnits(amount, privateDecimals);
      const tx = await privateContract.unshield(amountToUnshield);
      await tx.wait();
      notification.success("Unshield request submitted!");
      const clearContract = new ethers.Contract(tokenPair.clearAddress, CLEAR_TOKEN_ABI, provider);
      const prevBalance = (await clearContract.balanceOf(address)).toString();
      const waitingId = notification.info("Waiting for MPC to process unshield request...", { duration: 0 });
      const newBalance = await BlockchainService.pollForBalanceChange(clearContract, address, prevBalance, 20, 5000);
      if (waitingId) notification.remove(waitingId);
      if (newBalance !== prevBalance) {
        updateTokenPairBalance(tokenPair.privateAddress, { clearTokenBalance: newBalance });
        notification.success("Unshield completed!", { icon: "🎉" });
      } else {
        notification.warning("Unshield request submitted, but MPC processing is taking longer than expected.");
      }
    } catch (err: any) {
      console.error("Unshield error:", err);
      setShieldError(err?.message || "Failed to unshield tokens");
      notification.error("Failed to unshield tokens");
    } finally {
      setIsUnshielding(false);
    }
  };

  const mint = async (tokenPair: TokenPair, amount: string) => {
    if (!amount || !address) return;
    setIsMinting(true);
    try {
      const provider = new ethers.BrowserProvider(window.ethereum);
      const signer = await provider.getSigner();
      const clearContract = new ethers.Contract(tokenPair.clearAddress, CLEAR_TOKEN_ABI, signer);
      const amountToMint = ethers.parseUnits(amount, tokenPair.data.clearTokenDecimals || 18);
      const tx = await clearContract.mint(address, amountToMint);
      await tx.wait();
      const newBalance = await clearContract.balanceOf(address);
      updateTokenPairBalance(tokenPair.privateAddress, { clearTokenBalance: newBalance.toString() });
      notification.success("Mint successful!");
    } catch (err: any) {
      console.error("Mint error:", err);
      notification.error("Failed to mint tokens");
    } finally {
      setIsMinting(false);
    }
  };

  return {
    approvingTokens,
    isTransferring,
    isShielding,
    isUnshielding,
    isMinting,
    shieldError,
    handleApprove,
    transferClear,
    transferPrivate,
    shield,
    unshield,
    mint,
  } as const;
}; 