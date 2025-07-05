// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./soda/DecryptionCaller.sol";
import "./soda/MpcCore.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title ShieldedToken
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
contract ShieldedToken is DecryptionCaller {
    /// @dev This is stored as an immutable to save gas on repeated zero checks
    gtUint64 public immutable zero;

    /// @notice The number of decimal places for token amounts
    /// @dev Fixed at 5 decimals, allowing for precision up to 0.00001 tokens
    uint8 private immutable _decimals = 5;

    /// @notice Mapping of encrypted token balances for each address
    /// @dev The balance is stored as a handle that requires encryption and decryption under the user's secret key to get the actual value
    mapping(address => gtUint64) private balances;
    /// @notice Mapping of encrypted allowances for each address pair
    /// @dev The allowance is stored as a handle that requires decryption to get the actual value
    mapping(address => mapping(address => gtUint64)) private allowances;
    address public owner;
    IERC20 public underlying;

    // Storage for unshield requests
    struct UnshieldRequest {
        address user;
    }
    mapping(uint256 => UnshieldRequest) private unshieldRequests;

    /// @notice The name of the token
    string private _name;
    /// @notice The symbol of the token
    string private _symbol;
    /// @notice The total supply of tokens
    uint256 private _totalSupply;

    /// @notice Emitted when tokens are transferred
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of tokens transferred (only for clear transfers)
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    /// @notice Emitted when tokens are transferred (for encrypted transfers)
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    event Transfer(address indexed _from, address indexed _to);

    /// @notice Emitted when an approval is set
    /// @param _owner The address of the token owner
    /// @param _spender The address of the spender
    /// @param _value The amount of tokens approved (only for clear approvals)
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    /// @notice Emitted when an approval is set (for encrypted approvals)
    /// @param _owner The address of the token owner
    /// @param _spender The address of the spender
    event Approval(address indexed _owner, address indexed _spender);

    event Shield(address indexed from, uint256 amount);
    event Unshield(address indexed to, uint256 amount);
    event UnshieldRequested(address indexed to, uint256 amount);
    event UnshieldFailed(address indexed to, uint256 amount);

    /**
     * @dev Constructor that sets up the initial token configuration
     */
    constructor(string memory name_, string memory symbol_, address underlying_) {
        _name = name_;
        _symbol = symbol_;
        owner = msg.sender;
        underlying = IERC20(underlying_);
        zero = MpcCore.setPublic64(0);
        // Permit the contract to use the zero handle
        MpcCore.permitThis(zero);
    }

    /// @notice Returns the name of the token
    /// @return The token name
    function name() public view returns (string memory) {
        return _name;
    }
    /// @notice Returns the symbol of the token
    /// @return The token symbol
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /// @notice Returns the total supply of tokens
    /// @return The total supply
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /// @notice Returns the handle of the caller's balance
    /// @dev The balance is returned as a handle that requires encryption and decryption under the user's secret key to get the actual value
    /// @return The balance handle
    function balanceOf() public view returns (gtUint64) {
        return balances[msg.sender];
    }

    /// @notice Returns the handle to the balance of the given address
    /// @dev The balance is returned as a handle that requires encryption and decryption under the user's secret key to get the actual value.
    /// Returns zero handle if balance is uninitialized, which can be used by clients to determine if decryption is needed.
    /// @param add The address to get the balance from
    /// @return The balance handle (zero if uninitialized)
    function balanceOf(address add) public view returns (gtUint64) {
        return balances[add];
    }

    function transfer(address _to, itUint64 calldata _it) public returns (gtBool) {
        gtUint64 value = MpcCore.validateCiphertext(_it);
        MpcCore.permitTransient(value, msg.sender); // Give transient permission the the sender, so the contractTransfer check will pass
        return contractTransfer(_to, value);
    }

    /// @notice Transfers tokens using a clear value
    /// @param _to The address to transfer to
    /// @param _value The amount of tokens to transfer
    /// @return The handle to the transfer's result
    function transfer(address _to, uint64 _value) public returns (gtBool) {
        (gtUint64 fromBalance, gtUint64 toBalance) = _getBalances(msg.sender, _to);
        (gtUint64 newFromBalance, gtUint64 newToBalance, gtBool result) = MpcCore.transfer(
            fromBalance,
            toBalance,
            _value
        );
        _setNewBalances(msg.sender, _to, newFromBalance, newToBalance);
        emit Transfer(msg.sender, _to, _value);
        return result;
    }
    /// @notice Transfers the amount of tokens given in the handle _value to address _to
    /// @param _to The address to transfer to
    /// @param _value The handle to the amount of tokens to transfer
    /// @return The handle to the transfer's result
    function contractTransfer(address _to, gtUint64 _value) public returns (gtBool) {
        // Check if the sender is permitted to use the _value handle
        require(MpcCore.isSenderPermitted(_value));
        (gtUint64 fromBalance, gtUint64 toBalance) = _getBalances(msg.sender, _to);
        (gtUint64 newFromBalance, gtUint64 newToBalance, gtBool result) = MpcCore.transfer(
            fromBalance,
            toBalance,
            _value
        );
        _setNewBalances(msg.sender, _to, newFromBalance, newToBalance);
        emit Transfer(msg.sender, _to);
        return result;
    }

    /// @notice Transfers the amount of tokens given inside the IT (an encrypted and signed value) from one address to another
    /// @param _from The address to transfer from
    /// @param _to The address to transfer to
    /// @param _it The encrypted and signed transfer amount
    /// @return The handle to the transfer's result
    function transferFrom(address _from, address _to, itUint64 calldata _it) public returns (gtBool) {
        gtUint64 value = MpcCore.validateCiphertext(_it);
        MpcCore.permitTransient(value, msg.sender); // Give transient permission the the sender, so the contractTransferFrom check will pass
        return contractTransferFrom(_from, _to, value);
    }
    /// @notice Transfers the amount of tokens given in the clear from one address to another
    /// @param _from The address to transfer from
    /// @param _to The address to transfer to
    /// @param _value The amount of tokens to transfer
    /// @return The handle to the transfer's result
    function transferFrom(address _from, address _to, uint64 _value) public returns (gtBool) {
        (gtUint64 fromBalance, gtUint64 toBalance) = _getBalances(_from, _to);
        gtUint64 gtAllowance = _getGTAllowance(_from, msg.sender);
        (gtUint64 newFromBalance, gtUint64 newToBalance, gtBool result, gtUint64 newAllowance) = MpcCore
            .transferWithAllowance(fromBalance, toBalance, _value, gtAllowance);
        _setApproveValue(_from, msg.sender, newAllowance);
        _setNewBalances(_from, _to, newFromBalance, newToBalance);
        emit Transfer(_from, _to, _value);
        return result;
    }
    /// @notice Transfers the amount of tokens given in the handle from one address to another
    /// @param _from The address to transfer from
    /// @param _to The address to transfer to
    /// @param _value The encrypted transfer amount
    /// @return The handle to the transfer's result
    function contractTransferFrom(address _from, address _to, gtUint64 _value) public returns (gtBool) {
        // Check if the sender is permitted to use the _value handle
        require(MpcCore.isSenderPermitted(_value));
        (gtUint64 fromBalance, gtUint64 toBalance) = _getBalances(_from, _to);
        gtUint64 gtAllowance = _getGTAllowance(_from, msg.sender);
        (gtUint64 newFromBalance, gtUint64 newToBalance, gtBool result, gtUint64 newAllowance) = MpcCore
            .transferWithAllowance(fromBalance, toBalance, _value, gtAllowance);
        _setApproveValue(_from, msg.sender, newAllowance);
        _setNewBalances(_from, _to, newFromBalance, newToBalance);
        emit Transfer(_from, _to);
        return result;
    }

    /// @notice Approves a spender to transfer the amount of tokens given inside the IT (an encrypted and signed value)
    /// @param _spender The address that will be approved
    /// @param _it The encrypted and signed approval amount
    /// @return True if the approval was successful
    function approve(address _spender, itUint64 calldata _it) public returns (bool) {
        return contractApprove(_spender, MpcCore.validateCiphertext(_it));
    }
    /// @notice Approves a spender to transfer the amount of tokens given in the clear
    /// @param _spender The address that will be approved
    /// @param _value The amount of tokens to approve
    /// @return True if the approval was successful
    function approve(address _spender, uint64 _value) public returns (bool) {
        gtUint64 gt = MpcCore.setPublic64(_value);
        _setApproveValue(msg.sender, _spender, gt);
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    /// @notice Approves a spender to transfer the amount of tokens given in the handle
    /// @param _spender The address that will be approved
    /// @param _value The handle to the approval amount
    /// @return True if the approval was successful
    function contractApprove(address _spender, gtUint64 _value) public returns (bool) {
        // Check if the sender is permitted to use the _value handle
        require(MpcCore.isSenderPermitted(_value));
        _setApproveValue(msg.sender, _spender, _value);
        emit Approval(msg.sender, _spender);
        return true;
    }
    /// @notice Returns the handle to the allowance of a spender
    /// @dev The returned handle requires encryption and decryption under the user's secret key to get the actual value
    /// @param _owner The address of the token owner
    /// @param _spender The address of the spender
    /// @return The allowance handle
    function allowance(address _owner, address _spender) public view returns (gtUint64) {
        require(_owner == msg.sender || _spender == msg.sender);
        return _getGTAllowance(_owner, _spender);
    }

    function _getBalances(address _from, address _to) private view returns (gtUint64, gtUint64) {
        return (_balanceOf(_from), _balanceOf(_to));
    }

    function _balanceOf(address add) private view returns (gtUint64) {
        gtUint64 balance = balances[add];
        if (gtUint64.unwrap(balance) == 0) {
            // 0 means that no balance has been set, set it to 0
            balance = zero;
        }
        return balance;
    }

    /// @notice Sets the new balances handles for two addresses
    /// @param _from The address to set the balance for
    /// @param _to The address to set the balance for
    /// @param newFromBalance The new balance handle for _from
    /// @param newToBalance The new balance handle for _to
    function _setNewBalances(address _from, address _to, gtUint64 newFromBalance, gtUint64 newToBalance) private {
        // Store the new balances handles in the mapping
        balances[_from] = newFromBalance;
        balances[_to] = newToBalance;
        // Permit the contract and the _from user to use the balance handle
        MpcCore.permitThis(newFromBalance);
        MpcCore.permit(newFromBalance, _from);
        // Permit the contract and the _to to use the balance handle
        MpcCore.permitThis(newToBalance);
        MpcCore.permit(newToBalance, _to);
    }

    /// @notice Returns the handle to the allowance of a spender
    /// @param _owner The address of the token owner
    /// @param _spender The address of the spender
    /// @return The allowance handle
    function _getGTAllowance(address _owner, address _spender) private view returns (gtUint64) {
        if (gtUint64.unwrap(allowances[_owner][_spender]) == 0) {
            return zero;
        } else {
            return allowances[_owner][_spender];
        }
    }

    /// @notice Sets the new handle to the allowance for a spender
    /// @param _owner The address of the token owner
    /// @param _spender The address of the spender
    /// @param _value The new allowance handle
    function _setApproveValue(address _owner, address _spender, gtUint64 _value) private {
        allowances[_owner][_spender] = _value;
        // Permit the contract and the _owner user to use the allowance handle
        MpcCore.permitThis(_value);
        MpcCore.permit(_value, _owner);
    }

    /// @notice Returns the number of decimals used to get its user representation
    /// @return The number of decimals
    function decimals() public pure returns (uint8) {
        return _decimals;
    }

    // Function to shield standard ERC20 tokens into private tokens
    function shield(uint256 amount) public returns (bool) {
        require(amount > 0, "Amount must be greater than 0");
        uint256 privateAmount = amount / (10 ** (18 - decimals()));
        require(privateAmount > 0, "Amount too small after decimal conversion");
        require(underlying.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        gtUint64 balanceGt = _balanceOf(msg.sender);
        gtUint64 newBalanceGt = MpcCore.add(balanceGt, MpcCore.setPublic64(uint64(privateAmount)));
        balances[msg.sender] = newBalanceGt;
        _totalSupply += privateAmount;
        // Permit the contract and the user to use the new balance handle
        MpcCore.permitThis(newBalanceGt);
        MpcCore.permit(newBalanceGt, msg.sender);
        emit Shield(msg.sender, amount);
        return true;
    }

    // Function to unshield private tokens back to standard ERC20 tokens
    function unshield(uint256 privateAmount) public returns (bool) {
        require(privateAmount > 0, "Amount must be greater than 0");
        gtUint64 balanceGt = _balanceOf(msg.sender);
        gtUint64 amountGt = MpcCore.setPublic64(uint64(privateAmount));

        (, gtUint64 newBalanceGt) = MpcCore.checkedSubWithOverflowBit(balanceGt, amountGt);
        (gtBool overflowBit64, gtUint64 amountToUnshieldGt) = MpcCore.checkedSubWithOverflowBit(
            balanceGt,
            newBalanceGt
        );
        MpcCore.permitThis(amountToUnshieldGt);
        MpcCore.permitThis(newBalanceGt);
        MpcCore.permit(newBalanceGt, msg.sender);
        balances[msg.sender] = newBalanceGt;

        // user balance = 10, want to  unshield 3. checkedSubWithOverflowBit(10, 3) = 7, amount to unshield = bal before 10 sub new balance 7 = 3
        // user balance = 5, want to unshield 7. checkedSubWithOverflowBit(5, 7) = 5, amount to unshield = bal before 5 sub new balance 5 = 0

        // Create array for decryption request
        uint256[] memory handles = new uint256[](2);
        handles[0] = gtBool.unwrap(overflowBit64);
        handles[1] = gtUint64.unwrap(amountToUnshieldGt);

        // Store the request details
        unshieldRequests[decryptCounter] = UnshieldRequest({user: msg.sender});

        // Request decryption
        requestDecryption(handles, this.callbackUnshield.selector);

        emit UnshieldRequested(msg.sender, privateAmount);
        return true;
    }

    function callbackUnshield(uint256 decryptID, bytes[] calldata output, bytes calldata signature) public {
        require(checkCallbackHandles(decryptID, output.length), "checkSubOverflowResults: Invalid callback parameters");

        UnshieldRequest storage request = unshieldRequests[decryptID];
        require(request.user != address(0), "Invalid request ID");

        bool firstOverflowBit = abi.decode(output[0], (bool));
        uint64 amountToUnshield = abi.decode(output[1], (uint64));
        if (amountToUnshield > 0) {
            _totalSupply -= amountToUnshield;
            // Convert private amount (5 decimals) to underlying amount (18 decimals)
            uint256 underlyingAmount = amountToUnshield * (10 ** (18 - decimals()));
            require(underlying.transfer(request.user, underlyingAmount), "Transfer failed");
            emit Unshield(request.user, underlyingAmount);
        } else {
            emit UnshieldFailed(request.user, amountToUnshield);
        }

        // Clean up the request
        delete unshieldRequests[decryptID];
    }
}
