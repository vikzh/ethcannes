// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

uint256 constant PRECISION = 10 ** 6;

contract PrivateOrderBook is ReentrancyGuard, Pausable, Ownable {
  struct Order {
    address maker;
    address fromToken;
    address toToken;
    uint256 fromAmount;
    uint256 toAmount;
    uint256 timestamp;
    bool isActive;
  }

  Order[] public orders;
  
  event OrderAdded(uint256 indexed orderId, address indexed maker, address fromToken, address toToken, uint256 fromAmount, uint256 toAmount);
  event OrderExecuted(uint256 indexed orderId, address indexed maker, address indexed taker);
  event OrderCancelled(uint256 indexed orderId, address indexed maker);

  constructor() Ownable(msg.sender) {}

  /**
   * @dev Add a new order to the order book
   * @param newOrder The order to add
   * @return orderId The ID of the newly added order
   */
  function addOrder(Order memory newOrder) 
    external 
    whenNotPaused 
    nonReentrant 
    returns (uint256 orderId) 
  {
    require(newOrder.maker != address(0), "Invalid maker address");
    require(newOrder.fromToken != address(0), "Invalid fromToken address");
    require(newOrder.toToken != address(0), "Invalid toToken address");
    require(newOrder.fromToken != newOrder.toToken, "Cannot trade same token");
    require(newOrder.fromAmount > 0, "From amount must be greater than 0");
    require(newOrder.toAmount > 0, "To amount must be greater than 0");
    
    // Transfer maker tokens to this contract
    IERC20(newOrder.fromToken).transferFrom(newOrder.maker, address(this), newOrder.fromAmount);
    
    newOrder.timestamp = block.timestamp;
    newOrder.isActive = true;
    
    uint256 newPrice = newOrder.fromAmount * PRECISION / newOrder.toAmount;
    
    for (uint256 i = 0; i < orders.length; i++) {
      Order storage existingOrder = orders[i];
      
      if (!existingOrder.isActive) continue;
      
      if (existingOrder.fromToken == newOrder.toToken && 
          existingOrder.toToken == newOrder.fromToken) {
        
        uint256 existingPrice = existingOrder.fromAmount * PRECISION / existingOrder.toAmount;
        
        // If existing order price is better than new order price, execute the trade
        if (existingPrice >= newPrice) {
          _executeOrder(i, msg.sender, newOrder);
          return i;
        }
      }
    }

    // No matching order found, add to order book
    orders.push(newOrder);
    orderId = orders.length - 1;
    
    emit OrderAdded(orderId, newOrder.maker, newOrder.fromToken, newOrder.toToken, newOrder.fromAmount, newOrder.toAmount);
    return orderId;
  }

  /**
   * @dev Execute an order at the specified index
   * @param orderId The ID of the order to execute
   * @param taker The address taking the order
   * @param takerOrder The order from the taker
   */
  function _executeOrder(uint256 orderId, address taker, Order memory takerOrder) internal {
    require(orderId < orders.length, "Invalid order ID");
    require(orders[orderId].isActive, "Order is not active");
    
    Order storage makerOrder = orders[orderId];
    makerOrder.isActive = false;
    
    // Transfer tokens from maker to taker
    IERC20(makerOrder.fromToken).transferFrom(makerOrder.maker, taker, makerOrder.fromAmount);
    // Transfer tokens from taker to maker
    IERC20(takerOrder.fromToken).transferFrom(taker, makerOrder.maker, takerOrder.fromAmount);
    
    emit OrderExecuted(orderId, makerOrder.maker, taker);
  }

  /**
   * @dev Cancel an order (only the maker can cancel their own order)
   * @param orderId The ID of the order to cancel
   */
  function cancelOrder(uint256 orderId) external whenNotPaused {
    require(orderId < orders.length, "Invalid order ID");
    require(orders[orderId].isActive, "Order is not active");
    require(orders[orderId].maker == msg.sender, "Only maker can cancel order");

    orders[orderId].isActive = false;
    IERC20(orders[orderId].fromToken).transfer(orders[orderId].maker, orders[orderId].fromAmount);

    emit OrderCancelled(orderId, msg.sender);
  }

  /**
   * @dev Get order details by ID
   * @param orderId The ID of the order
   * @return The order details
   */
  function getOrder(uint256 orderId) external view returns (Order memory) {
    require(orderId < orders.length, "Invalid order ID");
    return orders[orderId];
  }

  /**
   * @dev Get all active orders
   * @return Array of active order IDs
   */
  function getActiveOrders() external view returns (uint256[] memory) {
    uint256 activeCount = 0;
    
    for (uint256 i = 0; i < orders.length; i++) {
      if (orders[i].isActive) {
        activeCount++;
      }
    }
    
    uint256[] memory activeOrders = new uint256[](activeCount);
    uint256 currentIndex = 0;
    
    for (uint256 i = 0; i < orders.length; i++) {
      if (orders[i].isActive) {
        activeOrders[currentIndex] = i;
        currentIndex++;
      }
    }
    return activeOrders;
  }

  /**
   * @dev Get total number of orders
   * @return Total number of orders
   */
  function getOrderCount() external view returns (uint256) {
    return orders.length;
  }

  /**
   * @dev Pause the contract (emergency stop)
   */
  function pause() external onlyOwner {
    _pause();
  }

  /**
   * @dev Unpause the contract
   */
  function unpause() external onlyOwner {
    _unpause();
  }
}
