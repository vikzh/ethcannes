import { useScaffoldReadContract, useScaffoldWriteContract } from "~~/hooks/scaffold-eth";
import { useTargetNetwork } from "~~/hooks/scaffold-eth/useTargetNetwork";
import { Address } from "viem";

export type TokenCreatedEvent = {
  token: Address;
  name: string;
  symbol: string;
  underlying: Address;
  creator: Address;
};

export const usePrivateTokenFactory = () => {
  const { targetNetwork } = useTargetNetwork();

  // Read total tokens created
  const { data: totalTokens, isLoading: isLoadingTotal } = useScaffoldReadContract({
    contractName: "PrivateERC20Factory",
    functionName: "totalTokensCreated",
  });

  // Check if a token is from this factory
  const checkTokenFromFactory = (tokenAddress: Address) => {
    const { data: isFromFactory } = useScaffoldReadContract({
      contractName: "PrivateERC20Factory",
      functionName: "isTokenFromFactory",
      args: [tokenAddress],
    });
    return isFromFactory;
  };

  // Create new private token
  const {
    writeContractAsync: createToken,
    isPending: isCreating,
    data: createTxHash,
  } = useScaffoldWriteContract({
    contractName: "PrivateERC20Factory",
  });

  const createPrivateToken = async (name: string, symbol: string, underlyingToken: Address) => {
    try {
      const result = await createToken({
        functionName: "createToken",
        args: [name, symbol, underlyingToken],
      });
      return result;
    } catch (error) {
      console.error("Failed to create private token:", error);
      throw error;
    }
  };

  return {
    // Data
    totalTokens: totalTokens ? Number(totalTokens) : 0,
    isLoadingTotal,
    
    // Functions
    createPrivateToken,
    checkTokenFromFactory,
    
    // Transaction states
    isCreating,
    createTxHash,
    
    // Network info
    factoryAddress: targetNetwork.id === 84532 ? "0x7e58A85165722785AE9CeaDa3D8c2188DCEADDAb" : undefined,
  };
};

export default usePrivateTokenFactory;