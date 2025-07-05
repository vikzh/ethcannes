import React from "react";
import dynamic from "next/dynamic";

// Dynamically import the EncryptionAnimation (client-side only)
const EncryptionAnimation = dynamic(() => import("./EncryptionAnimation"), { ssr: false });

interface TransactionAnimationProps {
  /**
   * Whether the animation should be visible.
   */
  isActive: boolean;
  /**
   * (Optional) The hash of the pending transaction.
   */
  transactionHash?: string | null;
}

/**
 * TransactionAnimation – combines the hex-mixing EncryptionAnimation with a small
 * status label so that forms (shield / unshield / etc.) can display a unified
 * progress indicator while a transaction is waiting to be confirmed.
 */
const TransactionAnimation: React.FC<TransactionAnimationProps> = ({ isActive, transactionHash }) => {
  if (!isActive) return null;

  const shortHash = transactionHash
    ? `${transactionHash.slice(0, 8)}...${transactionHash.slice(-6)}`
    : null;

  return (
    <div className="mt-4 transition-all duration-300">
      <EncryptionAnimation isActive={isActive} />
      <p className="text-center text-gray-600 text-xs mt-2">
        {shortHash ? `Processing transaction… ${shortHash}` : "Confirming transaction…"}
      </p>
    </div>
  );
};

export default TransactionAnimation; 