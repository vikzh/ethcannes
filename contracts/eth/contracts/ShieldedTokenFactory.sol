// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./ShieldedToken.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title ShieldedTokenFactory
/// @notice Factory contract for creating ShieldedToken tokens with MPC privacy features
/// @dev This factory allows users to deploy new instances of ShieldedToken with custom parameters
contract ShieldedTokenFactory {
    /// @notice Emitted when a new PrivateERC20 token is created
    /// @param token The address of the newly created token
    /// @param name The name of the token
    /// @param symbol The symbol of the token
    /// @param underlying The address of the underlying ERC20 token
    /// @param creator The address of the token creator
    event TokenCreated(
        address indexed token,
        string name,
        string symbol,
        address indexed underlying,
        address indexed creator
    );

    /// @notice Total number of tokens created by this factory
    uint256 public totalTokensCreated;
    
    /// @notice Mapping to check if a token was created by this factory
    mapping(address => bool) public isTokenFromFactory;

    /// @notice Creates a new PrivateERC20 token
    /// @param name The name of the new token
    /// @param symbol The symbol of the new token  
    /// @param underlying The address of the underlying ERC20 token to wrap
    /// @return token The address of the newly created PrivateERC20 token
    function createToken(
        string memory name,
        string memory symbol,
        address underlying
    ) external returns (address token) {
        require(bytes(name).length > 0, "Name cannot be empty");
        require(bytes(symbol).length > 0, "Symbol cannot be empty");
        require(underlying != address(0), "Underlying cannot be zero address");
        
        // Verify that the underlying address is a valid ERC20 contract
        // This will revert if the underlying address is not a valid ERC20
        IERC20 underlyingToken = IERC20(underlying);
        require(underlyingToken.totalSupply() >= 0, "Invalid ERC20 contract");

        ShieldedToken newToken = new ShieldedToken(name, symbol, underlying);
        token = address(newToken);

        // Mark token as created by this factory
        isTokenFromFactory[token] = true;
        totalTokensCreated++;

        emit TokenCreated(token, name, symbol, underlying, msg.sender);
    }
} 