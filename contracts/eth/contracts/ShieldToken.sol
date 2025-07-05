// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title ShieldToken
 * @dev A privacy-focused ERC20 token with additional security features
 * 
 * Features:
 * - Standard ERC20 functionality
 * - Pausable for emergency stops
 * - Minting capability for authorized addresses
 * - Burning capability for token holders
 * - Reentrancy protection
 * - Ownership controls
 */
contract ShieldToken is ERC20, Ownable, Pausable, ReentrancyGuard {
    
    // Maximum supply of tokens
    uint256 public constant MAX_SUPPLY = 1_000_000_000 * 10**18; // 1 billion tokens
    
    // Mapping to track authorized minters
    mapping(address => bool) public authorizedMinters;
    
    // Events
    event MinterAdded(address indexed minter);
    event MinterRemoved(address indexed minter);
    event TokensMinted(address indexed to, uint256 amount);
    event TokensBurned(address indexed from, uint256 amount);
    
    // Modifiers
    modifier onlyMinter() {
        require(authorizedMinters[msg.sender] || msg.sender == owner(), "ShieldToken: caller is not authorized to mint");
        _;
    }
    
    /**
     * @dev Constructor that sets up the initial token configuration
     * @param initialOwner The address that will own the contract
     * @param initialSupply The initial supply of tokens to mint to the owner
     */
    constructor(
        address initialOwner,
        uint256 initialSupply
    ) ERC20("ShieldToken", "SHIELD") Ownable(initialOwner) {
        require(initialSupply <= MAX_SUPPLY, "ShieldToken: initial supply exceeds max supply");
        
        if (initialSupply > 0) {
            _mint(initialOwner, initialSupply);
        }
        
        // Owner is automatically an authorized minter
        authorizedMinters[initialOwner] = true;
    }
    
    /**
     * @dev Mints new tokens to a specified address
     * @param to The address to mint tokens to
     * @param amount The amount of tokens to mint
     */
    function mint(address to, uint256 amount) 
        external 
        onlyMinter 
        whenNotPaused 
        nonReentrant 
    {
        require(to != address(0), "ShieldToken: cannot mint to zero address");
        require(amount > 0, "ShieldToken: amount must be greater than 0");
        require(totalSupply() + amount <= MAX_SUPPLY, "ShieldToken: would exceed max supply");
        
        _mint(to, amount);
        emit TokensMinted(to, amount);
    }
    
    /**
     * @dev Burns tokens from the caller's balance
     * @param amount The amount of tokens to burn
     */
    function burn(uint256 amount) 
        external 
        whenNotPaused 
        nonReentrant 
    {
        require(amount > 0, "ShieldToken: amount must be greater than 0");
        require(balanceOf(msg.sender) >= amount, "ShieldToken: insufficient balance");
        
        _burn(msg.sender, amount);
        emit TokensBurned(msg.sender, amount);
    }
    
    /**
     * @dev Burns tokens from a specified address (requires allowance)
     * @param from The address to burn tokens from
     * @param amount The amount of tokens to burn
     */
    function burnFrom(address from, uint256 amount) 
        external 
        whenNotPaused 
        nonReentrant 
    {
        require(amount > 0, "ShieldToken: amount must be greater than 0");
        require(balanceOf(from) >= amount, "ShieldToken: insufficient balance");
        
        uint256 currentAllowance = allowance(from, msg.sender);
        require(currentAllowance >= amount, "ShieldToken: burn amount exceeds allowance");
        
        _spendAllowance(from, msg.sender, amount);
        _burn(from, amount);
        emit TokensBurned(from, amount);
    }
    
    /**
     * @dev Adds an authorized minter
     * @param minter The address to authorize for minting
     */
    function addMinter(address minter) external onlyOwner {
        require(minter != address(0), "ShieldToken: cannot add zero address as minter");
        require(!authorizedMinters[minter], "ShieldToken: minter already authorized");
        
        authorizedMinters[minter] = true;
        emit MinterAdded(minter);
    }
    
    /**
     * @dev Removes an authorized minter
     * @param minter The address to remove from authorized minters
     */
    function removeMinter(address minter) external onlyOwner {
        require(authorizedMinters[minter], "ShieldToken: minter not authorized");
        require(minter != owner(), "ShieldToken: cannot remove owner as minter");
        
        authorizedMinters[minter] = false;
        emit MinterRemoved(minter);
    }
    
    /**
     * @dev Pauses all token transfers and minting
     */
    function pause() external onlyOwner {
        _pause();
    }
    
    /**
     * @dev Unpauses all token transfers and minting
     */
    function unpause() external onlyOwner {
        _unpause();
    }
    
    /**
     * @dev Override transfer function to include pausable functionality
     */
    function transfer(address to, uint256 amount) 
        public 
        override 
        whenNotPaused 
        returns (bool) 
    {
        return super.transfer(to, amount);
    }
    
    /**
     * @dev Override transferFrom function to include pausable functionality
     */
    function transferFrom(address from, address to, uint256 amount) 
        public 
        override 
        whenNotPaused 
        returns (bool) 
    {
        return super.transferFrom(from, to, amount);
    }
    
    /**
     * @dev Override approve function to include pausable functionality
     */
    function approve(address spender, uint256 amount) 
        public 
        override 
        whenNotPaused 
        returns (bool) 
    {
        return super.approve(spender, amount);
    }
    
    /**
     * @dev Returns the number of decimals used to get its user representation
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }
    
    /**
     * @dev Returns the maximum supply of tokens
     */
    function maxSupply() public pure returns (uint256) {
        return MAX_SUPPLY;
    }
    
    /**
     * @dev Returns the remaining tokens that can be minted
     */
    function remainingSupply() public view returns (uint256) {
        return MAX_SUPPLY - totalSupply();
    }
}
