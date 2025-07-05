// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract PrivateOrderBook {
  struct Order {
    address maker;
    address fromToken;
    address toToken;
    uint256 fromAmount;
    uint256 toAmount;
  }

  Order[] public orders;

  constructor(){}

  function addOrder(Order memory order) external {
    // Logic to add an order to the private order book
  }

}
