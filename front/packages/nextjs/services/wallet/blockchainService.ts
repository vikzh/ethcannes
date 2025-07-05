/**
 * Service class for blockchain and subgraph operations
 */

import { getSubgraphUrl } from "../../config/network";

// Interface for subgraph token data
export interface SubgraphToken {
  id: string;
  name: string;
  symbol: string;
  underlying: string;
  creator: string;
  factory: {
    id: string;
  };
}

// Interface for subgraph response
interface SubgraphResponse {
  data: {
    privateERC20Tokens: SubgraphToken[];
  };
}

export class BlockchainService {
  /**
   * Fetch tokens from subgraph for a specific network
   */
  static async fetchTokensFromSubgraph(chainId?: number): Promise<SubgraphToken[]> {
    try {
      const subgraphUrl = getSubgraphUrl(chainId);
      
      if (!subgraphUrl) {
        console.warn(`No subgraph URL configured for chain ${chainId}`);
        return [];
      }

      const query = `
        {
          privateERC20Tokens {
            id
            name
            symbol
            underlying
            creator
            factory {
              id
            }
          }
        }
      `;

      const response = await fetch(subgraphUrl, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ query }),
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const result: SubgraphResponse = await response.json();
      return result.data.privateERC20Tokens || [];
    } catch (error) {
      console.error("BlockchainService.fetchTokensFromSubgraph - Error:", error);
      return [];
    }
  }

  /**
   * Poll for balance change helper
   */
  static async pollForBalanceChange(
    contract: any,
    address: string,
    prevBalance: string,
    maxAttempts = 10,
    interval = 3000,
  ): Promise<string> {
    for (let i = 0; i < maxAttempts; i++) {
      const newBalance = (await contract.balanceOf(address)).toString();
      if (newBalance !== prevBalance) return newBalance;
      await new Promise(res => setTimeout(res, interval));
    }
    return prevBalance;
  }
} 