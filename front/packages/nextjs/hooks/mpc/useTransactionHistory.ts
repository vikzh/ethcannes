import { useState, useEffect } from "react";
import { useAccount, useChainId } from "wagmi";
import { ethers } from "ethers";
import { decryptUint } from "soda-sdk";
import { getSubgraphUrl, getRpcUrl } from "../../config/network";
import { getUserKeyFromStorage } from "../../utils/enc/cryptoUtils";

// Interface for unified transaction data
export interface HistoryTransaction {
  id: string;
  transactionHash: string;
  blockNumber: string;
  blockTimestamp: string;
  type: "Shield" | "Unshield" | "Transfer" | "EncryptedTransfer" | "UnshieldRequested" | "UnshieldFailed";
  tokenAddress: string;
  tokenName: string;
  tokenSymbol: string;
  from?: string;
  to?: string;
  amount?: string;
  encryptedAmount?: string; // For encrypted transfers that need decryption
  canDecrypt: boolean; // Whether the user can decrypt this transaction
  isDecrypted?: boolean; // Whether this transaction has been decrypted
  isDecrypting?: boolean; // Whether this transaction is currently being decrypted
}

// Transfer transaction interface
interface TransferTransaction {
  id: string;
  transactionHash: string;
  blockNumber: string;
  blockTimestamp: string;
  _from: string;
  _to: string;
  _value?: string; // Only present in transfers, not transfers1
  token: {
    id: string;
    name: string;
    symbol: string;
  };
}

// Subgraph response interfaces
interface SubgraphTransactionResponse {
  data: {
    shields: Array<{
      id: string;
      transactionHash: string;
      blockNumber: string;
      blockTimestamp: string;
      from: string;
      amount: string;
      token: {
        id: string;
        name: string;
        symbol: string;
      };
    }>;
    unshields: Array<{
      id: string;
      transactionHash: string;
      blockNumber: string;
      blockTimestamp: string;
      to: string;
      amount: string;
      token: {
        id: string;
        name: string;
        symbol: string;
      };
    }>;
    transfersFrom: TransferTransaction[];
    transfersTo: TransferTransaction[];
    transfers1From: TransferTransaction[];
    transfers1To: TransferTransaction[];
    unshieldRequesteds: Array<{
      id: string;
      transactionHash: string;
      blockNumber: string;
      blockTimestamp: string;
      to: string;
      amount: string;
      token: {
        id: string;
        name: string;
        symbol: string;
      };
    }>;
    unshieldFaileds: Array<{
      id: string;
      transactionHash: string;
      blockNumber: string;
      blockTimestamp: string;
      to: string;
      amount: string;
      token: {
        id: string;
        name: string;
        symbol: string;
      };
    }>;
  };
}

// ABI for private token contract
const PRIVATE_TOKEN_ABI = [
  "event Transfer(address indexed _from, address indexed _to, uint256 _value)",  // Clear transfer
  "event Transfer(address indexed _from, address indexed _to)",                   // Encrypted transfer
  "function transfer(address,(uint256 ciphertext, bytes signature))",
];

export const useTransactionHistory = () => {
  const { address } = useAccount();
  const chainId = useChainId();
  const [transactions, setTransactions] = useState<HistoryTransaction[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [decryptingTxs, setDecryptingTxs] = useState<Set<string>>(new Set());

  const fetchTransactionHistory = async () => {
    if (!address) {
      setTransactions([]);
      return;
    }

    setIsLoading(true);
    setError(null);

    try {
      const subgraphUrl = getSubgraphUrl(chainId);
      
      if (!subgraphUrl) {
        throw new Error(`No subgraph URL configured for chain ${chainId}`);
      }

      // GraphQL query to fetch all transaction types where user is involved
      // Note: The Graph doesn't support OR queries in a single filter, so we need separate queries
      const query = `
        query GetUserTransactions($userAddress: Bytes!) {
          shields(
            where: { from: $userAddress }
            orderBy: blockTimestamp
            orderDirection: desc
            first: 100
          ) {
            id
            transactionHash
            blockNumber
            blockTimestamp
            from
            amount
            token {
              id
              name
              symbol
            }
          }
          
          unshields(
            where: { to: $userAddress }
            orderBy: blockTimestamp
            orderDirection: desc
            first: 100
          ) {
            id
            transactionHash
            blockNumber
            blockTimestamp
            to
            amount
            token {
              id
              name
              symbol
            }
          }
          
          transfersFrom: transfers(
            where: { _from: $userAddress }
            orderBy: blockTimestamp
            orderDirection: desc
            first: 50
          ) {
            id
            transactionHash
            blockNumber
            blockTimestamp
            _from
            _to
            _value
            token {
              id
              name
              symbol
            }
          }
          
          transfersTo: transfers(
            where: { _to: $userAddress }
            orderBy: blockTimestamp
            orderDirection: desc
            first: 50
          ) {
            id
            transactionHash
            blockNumber
            blockTimestamp
            _from
            _to
            _value
            token {
              id
              name
              symbol
            }
          }
          
          transfers1From: transfer1S(
            where: { _from: $userAddress }
            orderBy: blockTimestamp
            orderDirection: desc
            first: 50
          ) {
            id
            transactionHash
            blockNumber
            blockTimestamp
            _from
            _to
            token {
              id
              name
              symbol
            }
          }
          
          transfers1To: transfer1S(
            where: { _to: $userAddress }
            orderBy: blockTimestamp
            orderDirection: desc
            first: 50
          ) {
            id
            transactionHash
            blockNumber
            blockTimestamp
            _from
            _to
            token {
              id
              name
              symbol
            }
          }
          
          unshieldRequesteds(
            where: { to: $userAddress }
            orderBy: blockTimestamp
            orderDirection: desc
            first: 100
          ) {
            id
            transactionHash
            blockNumber
            blockTimestamp
            to
            amount
            token {
              id
              name
              symbol
            }
          }
          
          unshieldFaileds(
            where: { to: $userAddress }
            orderBy: blockTimestamp
            orderDirection: desc
            first: 100
          ) {
            id
            transactionHash
            blockNumber
            blockTimestamp
            to
            amount
            token {
              id
              name
              symbol
            }
          }
        }
      `;

      const response = await fetch(subgraphUrl, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ 
          query,
          variables: { userAddress: address.toLowerCase() }
        }),
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const result: SubgraphTransactionResponse = await response.json();

      if (!result.data) {
        throw new Error("Invalid response from subgraph");
      }

      // Transform and combine all transaction types
      const allTransactions: HistoryTransaction[] = [];

      // Shield transactions (user sending to private)
      result.data.shields.forEach(shield => {
        allTransactions.push({
          id: shield.id,
          transactionHash: shield.transactionHash,
          blockNumber: shield.blockNumber,
          blockTimestamp: shield.blockTimestamp,
          type: "Shield",
          tokenAddress: shield.token.id,
          tokenName: shield.token.name,
          tokenSymbol: shield.token.symbol,
          from: shield.from,
          to: shield.token.id, // Private token address
          amount: shield.amount,
          canDecrypt: false, // Shield amounts are always public
        });
      });

      // Unshield transactions (user receiving from private)
      result.data.unshields.forEach(unshield => {
        allTransactions.push({
          id: unshield.id,
          transactionHash: unshield.transactionHash,
          blockNumber: unshield.blockNumber,
          blockTimestamp: unshield.blockTimestamp,
          type: "Unshield",
          tokenAddress: unshield.token.id,
          tokenName: unshield.token.name,
          tokenSymbol: unshield.token.symbol,
          from: unshield.token.id, // Private token address
          to: unshield.to,
          amount: unshield.amount,
          canDecrypt: false, // Unshield amounts are always public
        });
      });

      // Clear transfers (public amounts) - combine from and to
      const allClearTransfers = [...result.data.transfersFrom, ...result.data.transfersTo];
      allClearTransfers.forEach(transfer => {
        allTransactions.push({
          id: transfer.id,
          transactionHash: transfer.transactionHash,
          blockNumber: transfer.blockNumber,
          blockTimestamp: transfer.blockTimestamp,
          type: "Transfer",
          tokenAddress: transfer.token.id,
          tokenName: transfer.token.name,
          tokenSymbol: transfer.token.symbol,
          from: transfer._from,
          to: transfer._to,
          amount: transfer._value || "0",
          canDecrypt: false, // Clear transfers don't need decryption
        });
      });

      // Encrypted transfers (private amounts that may need decryption) - combine from and to
      const allEncryptedTransfers = [...result.data.transfers1From, ...result.data.transfers1To];
      allEncryptedTransfers.forEach(transfer => {
        allTransactions.push({
          id: transfer.id,
          transactionHash: transfer.transactionHash,
          blockNumber: transfer.blockNumber,
          blockTimestamp: transfer.blockTimestamp,
          type: "EncryptedTransfer",
          tokenAddress: transfer.token.id,
          tokenName: transfer.token.name,
          tokenSymbol: transfer.token.symbol,
          from: transfer._from,
          to: transfer._to,
          amount: "****", // Encrypted amount, needs decryption
          encryptedAmount: "encrypted", // Placeholder - actual decryption would need transaction data
          canDecrypt: true, // User can potentially decrypt if they have the key
        });
      });

      // Unshield requested
      result.data.unshieldRequesteds.forEach(request => {
        allTransactions.push({
          id: request.id,
          transactionHash: request.transactionHash,
          blockNumber: request.blockNumber,
          blockTimestamp: request.blockTimestamp,
          type: "UnshieldRequested",
          tokenAddress: request.token.id,
          tokenName: request.token.name,
          tokenSymbol: request.token.symbol,
          from: request.token.id,
          to: request.to,
          amount: request.amount,
          canDecrypt: false,
        });
      });

      // Unshield failed
      result.data.unshieldFaileds.forEach(failed => {
        allTransactions.push({
          id: failed.id,
          transactionHash: failed.transactionHash,
          blockNumber: failed.blockNumber,
          blockTimestamp: failed.blockTimestamp,
          type: "UnshieldFailed",
          tokenAddress: failed.token.id,
          tokenName: failed.token.name,
          tokenSymbol: failed.token.symbol,
          from: failed.token.id,
          to: failed.to,
          amount: failed.amount,
          canDecrypt: false,
        });
      });

      // Remove duplicates (can happen when user transfers to themselves or multiple matching queries)
      const uniqueTransactions = allTransactions.filter((transaction, index, self) =>
        index === self.findIndex(t => t.id === transaction.id)
      );

      // Sort all transactions by timestamp (most recent first)
      uniqueTransactions.sort((a, b) => parseInt(b.blockTimestamp) - parseInt(a.blockTimestamp));

      setTransactions(uniqueTransactions);
    } catch (error) {
      console.error("Error fetching transaction history:", error);
      setError(error instanceof Error ? error.message : "Failed to fetch transaction history");
    } finally {
      setIsLoading(false);
    }
  };

  const decryptTransaction = async (transaction: HistoryTransaction) => {
    const userKey = getUserKeyFromStorage();
    if (!userKey || !address || transaction.type !== "EncryptedTransfer") {
      return;
    }

    // Allow retrying failed decryptions
    if (transaction.isDecrypted && transaction.amount !== "Error") {
      return;
    }

    const txKey = transaction.id;
    setDecryptingTxs(prev => new Set(prev).add(txKey));

    // Update transaction to show it's being decrypted
    setTransactions(prevTxs =>
      prevTxs.map(tx =>
        tx.id === transaction.id ? { ...tx, isDecrypting: true, isDecrypted: false } : tx
      )
    );

    try {
      const isSender = transaction.from?.toLowerCase() === address.toLowerCase();
      const isRecipient = transaction.to?.toLowerCase() === address.toLowerCase();
      
      if (!isSender && !isRecipient) {
        throw new Error("You can only decrypt transactions where you are the sender or recipient");
      }

      // Get the full transaction to extract the ciphertext
      const provider = new ethers.JsonRpcProvider(getRpcUrl(chainId));
      const privateToken = new ethers.Contract(transaction.tokenAddress, PRIVATE_TOKEN_ABI, provider);
      
      const fullTx = await provider.getTransaction(transaction.transactionHash);
      if (!fullTx) {
        throw new Error("Transaction not found");
      }

      // Parse the transaction data to extract function call parameters
      let parsedTransaction;
      try {
        parsedTransaction = privateToken.interface.parseTransaction({
          data: fullTx.data,
          value: fullTx.value,
        });
      } catch (parseError) {
        console.error("Failed to parse transaction:", parseError);
        throw new Error("Failed to parse transfer transaction");
      }

      if (!parsedTransaction) {
        throw new Error("Could not parse transaction data");
      }

      let amountToDecrypt: bigint;

      // Handle different types of transfer functions
      if (parsedTransaction.name === "transfer" && parsedTransaction.args.length >= 2) {
        // Transfer function with encrypted parameter: transfer(address, (uint256 ciphertext, bytes signature))
        const transferData = parsedTransaction.args[1]; // The tuple parameter
        
        if (transferData && (transferData.ciphertext || transferData[0])) {
          amountToDecrypt = transferData.ciphertext || transferData[0]; // Get ciphertext field
        } else {
          throw new Error("Could not extract ciphertext from transaction");
        }
      } else {
        throw new Error(`Unsupported transaction type: ${parsedTransaction.name}`);
      }
      
      // Decrypt the amount using the user's AES key
      const decrypted = decryptUint(amountToDecrypt, userKey);
      
      // Format the decrypted amount (private tokens typically use 5 decimals)
      const decryptedAmount = ethers.formatUnits(decrypted, 5);

      // Update the transaction with the decrypted amount
      setTransactions(prevTxs =>
        prevTxs.map(tx =>
          tx.id === transaction.id 
            ? { 
                ...tx, 
                amount: decryptedAmount, 
                isDecrypted: true, 
                isDecrypting: false 
              } 
            : tx
        )
      );

    } catch (error) {
      console.error("Failed to decrypt transaction:", error);
      
      // Update transaction to show error state
      setTransactions(prevTxs =>
        prevTxs.map(tx =>
          tx.id === transaction.id 
            ? { 
                ...tx, 
                amount: "Error", 
                isDecrypted: true, 
                isDecrypting: false 
              } 
            : tx
        )
      );
    } finally {
      setDecryptingTxs(prev => {
        const newSet = new Set(prev);
        newSet.delete(txKey);
        return newSet;
      });
    }
  };

  useEffect(() => {
    fetchTransactionHistory();
  }, [address, chainId]);

  return {
    transactions,
    isLoading,
    error,
    refetch: fetchTransactionHistory,
    decryptTransaction,
  };
}; 