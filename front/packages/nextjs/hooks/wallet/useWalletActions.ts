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
  onActionComplete: () => void = () => {},
) => {
  const { address } = useAccount();

  const [approvingTokens, setApprovingTokens] = useState<Set<string>>(new Set());
  const [isTransferring, setIsTransferring] = useState(false);
  const [isShielding, setIsShielding] = useState(false);
  const [isUnshielding, setIsUnshielding] = useState(false);
  const [isMinting, setIsMinting] = useState(false);
  const [shieldError, setShieldError] = useState<string | undefined>(undefined);
  const tokenAllowances: Record<string, string> = {};
  const [approvedTokens, setApprovedTokens] = useState<Set<string>>(new Set());

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
      setApprovedTokens(prev => new Set(prev).add(tokenPair.privateAddress));
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

  /**
   * Helper to await a transaction, then poll for clear-token balance change and handle UI updates.
   */
  const handleTxWithClearBalanceChange = async (
    tx: any,
    clearContract: ethers.Contract,
    prevBalance: string,
    tokenPair: TokenPair,
    waitingMsg: string,
    completedMsg: string,
    resetPrivateBalance = false,
  ) => {
    await tx.wait();
    notification.success(`${completedMsg} transaction mined!`);

    const waitingId = notification.info(waitingMsg, { duration: 0 });
    const newBalance = await BlockchainService.pollForBalanceChange(
      clearContract,
      address as string,
      prevBalance,
      20,
      5000,
    );
    if (waitingId) notification.remove(waitingId);

    if (newBalance !== prevBalance) {
      const updates: any = { clearTokenBalance: newBalance };
      if (resetPrivateBalance) updates.privateTokenBalance = undefined;
      updateTokenPairBalance(tokenPair.privateAddress, updates);
      notification.success(`${completedMsg} completed!`, { icon: "🎉" });
      onActionComplete();
    } else {
      notification.warning(`${completedMsg} submitted, but processing is taking longer than expected.`);
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
      const prevClearBalance = (await contract.balanceOf(address)).toString();

      const tx = await contract.transfer(recipient, amountInDecimals);
      await handleTxWithClearBalanceChange(
        tx,
        contract,
        prevClearBalance,
        tokenPair,
        "Waiting for balance update after transfer...",
        "Transfer",
        false,
      );
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
      notification.success("Private transfer successful!");

      // Reset cached private balance so user decrypts again for updated value
      updateTokenPairBalance(tokenPair.privateAddress, { privateTokenBalance: undefined });

      onActionComplete();
    } catch (err: any) {
      console.error("Send error:", err);
      notification.error("Send failed: " + (err.message || "Unknown error"));
    } finally {
      setIsTransferring(false);
    }
  };

  const shield = async (tokenPair: TokenPair, amount: string) => {
    if (!amount || !address) return;
    setShieldError(undefined);
    try {
      const provider = new ethers.BrowserProvider(window.ethereum);
      const signer = await provider.getSigner();
      const clearTokenDecimals = tokenPair.data.clearTokenDecimals || 18;
      const amountToShield = ethers.parseUnits(amount, clearTokenDecimals);
      const clearContract = new ethers.Contract(tokenPair.clearAddress, CLEAR_TOKEN_ABI, provider);

      // -------- Pre-transaction validations --------
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

      // -------- User signature & tx broadcast --------
      const privateContract = new ethers.Contract(tokenPair.privateAddress, PRIVATE_TOKEN_ABI, signer);
      const prevClearBalance = (await clearContract.balanceOf(address)).toString();

      const tx = await privateContract.shield(amountToShield); // <-- user signs here

      // Start animation/progress after successful signature
      setIsShielding(true);

      await handleTxWithClearBalanceChange(
        tx,
        clearContract,
        prevClearBalance,
        tokenPair,
        "Waiting for MPC to process shield request...",
        "Shield",
        true,
      );
    } catch (err: any) {
      console.error("Shield error:", err);
      setShieldError(err?.message || "Failed to shield tokens");
      notification.error("Failed to shield tokens");
    } finally {
      // Ensure we stop the animation regardless of outcome
      setIsShielding(false);
    }
  };

  const unshield = async (tokenPair: TokenPair, amount: string) => {
    if (!amount || !address) return;
    setShieldError(undefined);
    try {
      const provider = new ethers.BrowserProvider(window.ethereum);
      const signer = await provider.getSigner();
      const privateContract = new ethers.Contract(tokenPair.privateAddress, PRIVATE_TOKEN_ABI, signer);
      const privateDecimals = tokenPair.data.privateTokenDecimals ?? 5;
      const amountToUnshield = ethers.parseUnits(amount, privateDecimals);

      const tx = await privateContract.unshield(amountToUnshield); // <-- user signs here

      // Start animation/progress after signature
      setIsUnshielding(true);

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
        onActionComplete();
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

      // Balance before mint
      const prevClearBalance = (await clearContract.balanceOf(address)).toString();

      const tx = await clearContract.mint(address, amountToMint);
      await handleTxWithClearBalanceChange(
        tx,
        clearContract,
        prevClearBalance,
        tokenPair,
        "Waiting for balance update after mint...",
        "Mint",
        true,
      );
    } catch (err: any) {
      console.error("Mint error:", err);
      notification.error("Failed to mint tokens");
    } finally {
      setIsMinting(false);
    }
  };

  const isTokenApproved = (privateAddress: string) => approvedTokens.has(privateAddress);

  const refreshAllowance = async (tokenPair: TokenPair) => {
    if (!address) return;
    try {
      const provider = new ethers.BrowserProvider(window.ethereum);
      const clearContract = new ethers.Contract(tokenPair.clearAddress, CLEAR_TOKEN_ABI, provider);
      const allowance = await clearContract.allowance(address, tokenPair.privateAddress);
      setApprovedTokens(prev => {
        const next = new Set(prev);
        if (allowance > 0n) next.add(tokenPair.privateAddress);
        else next.delete(tokenPair.privateAddress);
        return next;
      });
    } catch {}
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
    isTokenApproved,
    refreshAllowance,
  } as const;
}; 