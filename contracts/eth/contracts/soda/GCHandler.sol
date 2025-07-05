// SPDX-License-Identifier: BSD-3-Clause-Clear
pragma solidity >=0.8.13 <0.9.0;

import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import "./MpcInterface.sol";
import "./GCACLAddress.sol";

struct CounterStorage {
    uint256 counter; // tracks the number of decryption requests, and used to compute the requestID by hashing it with the dApp address
}

/// @title    GCHandler
/// @notice   This contract emits events for all GC operations.
/// @dev      This contract is deployed using an UUPS proxy.
contract GCHandler {

    uint8[5] MPC_SIZES = [1, 8, 16, 32, 64];
    enum METADATA_INDICES {ZERO, ONE, TWO, THREE, FOUR}
    string constant MESSAGE_PREFIX = "Ethereum Signed Message:\n";
    CounterStorage internal decryptionOracleStorage;
    CounterStorage internal randStorage;

    GCACL constant acl = GCACL(address(GCACLAddress));

    /// @notice         Returned if the signature is invalid.
    error InvalidSignature();

    /// @notice         Returned if the caller is not permitted to access the handle.
    /// @param handle   Handle.
    /// @param sender   Sender address.
    error ACLNotPermitted(uint256 handle, address sender);

    event GCBinaryOperation(string opName, uint8 lhsBitSize, uint8 rhsBitSize, bytes1 inputTypes, uint256 lhsParameter, uint256 rhsParameter, uint256 resultHandle);
    event GCOnboard(uint8 bitSize, uint256 ct, address userAddress, uint256 resultHandle);
    event GCCheckedBinaryOperation(string opName, uint8 lhsBitSize, uint8 rhsBitSize, bytes1 inputTypes, uint256 lhsParameter, uint256 rhsParameter, uint256 overflowHandle, uint256 resultHandle);
    event GCTransfer(uint8 fromBitSize, uint8 toBitSize, uint8 amountBitSize, bytes1 amountType, uint256 from, uint256 to, uint256 amount, uint256 newFromHandle, uint256 newToHandle, uint256 resultHandle);
    event GCTransferWithAllowance(uint8 fromBitSize, uint8 toBitSize, uint8 amountBitSize, uint8 allowanceBitSize, bytes1 amountType, uint256 from, uint256 to, uint256 amount, uint256 allowance, uint256 newFromHandle, uint256 newToHandle, uint256 newAllowanceHandle, uint256 resultHandle);
    event GCMux(uint8 lhsBitSize, uint8 rhsBitSize, bytes1 inputTypes, uint256 bitParameter, uint256 lhsParameter, uint256 rhsParameter, uint256 resultHandle);
    event GCRand(uint8 bitSize, uint256 resultHandle);
    event GCUnaryOperation(string opName, uint8 parameterBitSize, uint256 parameter, uint256 resultHandle);
    event GCDecryptionRequest(uint256 indexed counter, uint256 decryptID, uint256[] handles, address contractCaller, bytes4 callbackSelector);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
    }

    function getSize(bytes1 size) internal view returns (uint8) {
        // simple bounds check
        uint256 idx = uint8(size);
        require(idx < MPC_SIZES.length, "Invalid size");
        return MPC_SIZES[idx];
    }

    function checkACL(uint256 handle) internal view returns (bool) {
        return acl.isPermitted(handle, msg.sender);
    }

    function checkACLBinary(uint256 lhsParam, uint256 rhsParam, bytes1 inputTypes) internal view returns (bool) {
        if (inputTypes == bytes1(uint8(0))) { // both parameters are handles
            if (!checkACL(lhsParam)) revert ACLNotPermitted(lhsParam, msg.sender);
            if (!checkACL(rhsParam)) revert ACLNotPermitted(rhsParam, msg.sender);
        } else if (inputTypes == bytes1(uint8(1))) { // lhsParam is a public, rhsParam is a handle
            if (!checkACL(rhsParam)) revert ACLNotPermitted(rhsParam, msg.sender);
        } else if (inputTypes == bytes1(uint8(2))) { // rhsParam is a public, lhsParam is a handle
            if (!checkACL(lhsParam)) revert ACLNotPermitted(lhsParam, msg.sender);
        }
        return true;
    }

    /// @notice              Computes Add operation.
    /// @param metadata      Meta data.
    /// @param lhsParam      LHS parameter.
    /// @param rhsParam      RHS parameter.
    /// @return resultHandle Result handle.
    function Add(bytes3 metadata, uint256 lhsParam, uint256 rhsParam) public virtual returns (uint256 resultHandle) {

        uint8 lhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ZERO)]);
        uint8 rhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ONE)]);
        bytes1 inputTypes = metadata[uint8(METADATA_INDICES.TWO)];

        // Check that the caller is permitted to access the parameters
        checkACLBinary(lhsParam, rhsParam, inputTypes);

        resultHandle = uint256(keccak256(abi.encodePacked("Add", lhsParam, rhsParam, metadata)));
        // Permit the calling contract to access the result handle
        acl.permitTransient(resultHandle, msg.sender);

        emit GCBinaryOperation("ADD", lhsBitSize, rhsBitSize, inputTypes, lhsParam, rhsParam, resultHandle);
    }

    /// @notice                Computes Checked Add operation.
    /// @param metadata        Meta data.
    /// @param lhsParam        LHS parameter.
    /// @param rhsParam        RHS parameter.
    /// @return overflowHandle Overflow handle.
    /// @return resultHandle   Result handle.
    function CheckedAdd(bytes3 metadata, uint256 lhsParam, uint256 rhsParam) public virtual returns (uint256 overflowHandle, uint256 resultHandle) {

        uint8 lhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ZERO)]);
        uint8 rhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ONE)]);
        bytes1 inputTypes = metadata[uint8(METADATA_INDICES.TWO)];

        // Check that the caller is permitted to access the parameters
        checkACLBinary(lhsParam, rhsParam, inputTypes);

        resultHandle = uint256(keccak256(abi.encodePacked("CheckedAdd", lhsParam, rhsParam, metadata)));
        overflowHandle = uint256(keccak256(abi.encodePacked("CheckedAddOverflow", lhsParam, rhsParam, metadata)));
        // Permit the calling contract to access the result and overflow handles
        acl.permitTransient(resultHandle, msg.sender);
        acl.permitTransient(overflowHandle, msg.sender);

        emit GCCheckedBinaryOperation("ADDWITHOVERFLOWBIT", lhsBitSize, rhsBitSize, inputTypes, lhsParam, rhsParam, overflowHandle, resultHandle);
    }

    /// @notice              Computes Sub operation.
    /// @param metadata      Meta data.
    /// @param lhsParam      LHS parameter.
    /// @param rhsParam      RHS parameter.
    /// @return resultHandle Result handle.
    function Sub(bytes3 metadata, uint256 lhsParam, uint256 rhsParam) public virtual returns (uint256 resultHandle) {
        uint8 lhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ZERO)]);
        uint8 rhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ONE)]);
        bytes1 inputTypes = metadata[uint8(METADATA_INDICES.TWO)];

        // Check that the caller is permitted to access the parameters
        checkACLBinary(lhsParam, rhsParam, inputTypes);

        resultHandle = uint256(keccak256(abi.encodePacked("Sub", lhsParam, rhsParam, metadata)));
        // Permit the calling contract to access the result handle
        acl.permitTransient(resultHandle, msg.sender);

        emit GCBinaryOperation("SUB", lhsBitSize, rhsBitSize, inputTypes, lhsParam, rhsParam, resultHandle);
    }

    /// @notice                Computes Checked Sub operation.
    /// @param metadata        Meta data.
    /// @param lhsParam        LHS parameter.
    /// @param rhsParam        RHS parameter.
    /// @return overflowHandle Overflow handle.
    /// @return resultHandle   Result handle.
    function CheckedSub(bytes3 metadata, uint256 lhsParam, uint256 rhsParam) public virtual returns (uint256 overflowHandle, uint256 resultHandle) {
        uint8 lhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ZERO)]);
        uint8 rhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ONE)]);
        bytes1 inputTypes = metadata[uint8(METADATA_INDICES.TWO)];

        // Check that the caller is permitted to access the parameters
        checkACLBinary(lhsParam, rhsParam, inputTypes);

        resultHandle = uint256(keccak256(abi.encodePacked("CheckedSub", lhsParam, rhsParam, metadata)));
        overflowHandle = uint256(keccak256(abi.encodePacked("CheckedSubOverflow", lhsParam, rhsParam, metadata)));
        // Permit the calling contract to access the result and overflow handles
        acl.permitTransient(resultHandle, msg.sender);
        acl.permitTransient(overflowHandle, msg.sender);

        emit GCCheckedBinaryOperation("SUBWITHOVERFLOWBIT", lhsBitSize, rhsBitSize, inputTypes, lhsParam, rhsParam, overflowHandle, resultHandle);
    }

    /// @notice              Computes Mul operation.
    /// @param metadata      Meta data.
    /// @param lhsParam      LHS parameter.
    /// @param rhsParam      RHS parameter.
    /// @return resultHandle Result handle.
    function Mul(bytes3 metadata, uint256 lhsParam, uint256 rhsParam) public virtual returns (uint256 resultHandle) {
        uint8 lhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ZERO)]);
        uint8 rhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ONE)]);
        bytes1 inputTypes = metadata[uint8(METADATA_INDICES.TWO)];

        // Check that the caller is permitted to access the parameters
        checkACLBinary(lhsParam, rhsParam, inputTypes);

        resultHandle = uint256(keccak256(abi.encodePacked("Mul", lhsParam, rhsParam, metadata)));
        // Permit the calling contract to access the result handle
        acl.permitTransient(resultHandle, msg.sender);

        emit GCBinaryOperation("MUL", lhsBitSize, rhsBitSize, inputTypes, lhsParam, rhsParam, resultHandle);
    }


    /// @notice                Computes Checked Mul operation.
    /// @param metadata        Meta data.
    /// @param lhsParam        LHS parameter.
    /// @param rhsParam        RHS parameter.
    /// @return overflowHandle Overflow handle.
    /// @return resultHandle   Result handle.
    function CheckedMul(bytes3 metadata, uint256 lhsParam, uint256 rhsParam) public virtual returns (uint256 overflowHandle, uint256 resultHandle) {
        uint8 lhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ZERO)]);
        uint8 rhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ONE)]);
        bytes1 inputTypes = metadata[uint8(METADATA_INDICES.TWO)];

        // Check that the caller is permitted to access the parameters
        checkACLBinary(lhsParam, rhsParam, inputTypes);

        resultHandle = uint256(keccak256(abi.encodePacked("CheckedMul", lhsParam, rhsParam, metadata)));
        overflowHandle = uint256(keccak256(abi.encodePacked("CheckedMulOverflow", lhsParam, rhsParam, metadata)));
        // Permit the calling contract to access the result handle
        acl.permitTransient(resultHandle, msg.sender);
        acl.permitTransient(overflowHandle, msg.sender);

        emit GCCheckedBinaryOperation("MULWITHOVERFLOWBIT", lhsBitSize, rhsBitSize, inputTypes, lhsParam, rhsParam, overflowHandle, resultHandle);
    }

    /// @notice              Computes Le (Less than or Equal) operation.
    /// @param metadata      Meta data.
    /// @param lhsParam      LHS parameter.
    /// @param rhsParam      RHS parameter.
    /// @return resultHandle Result handle.
    function Le(bytes3 metadata, uint256 lhsParam, uint256 rhsParam) public virtual returns (uint256 resultHandle) {
        uint8 lhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ZERO)]);
        uint8 rhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ONE)]);
        bytes1 inputTypes = metadata[uint8(METADATA_INDICES.TWO)];

        // Check that the caller is permitted to access the parameters
        checkACLBinary(lhsParam, rhsParam, inputTypes);

        resultHandle = uint256(keccak256(abi.encodePacked("Le", lhsParam, rhsParam, metadata)));
        //
        acl.permitTransient(resultHandle, msg.sender);

        emit GCBinaryOperation("LE", lhsBitSize, rhsBitSize, inputTypes, lhsParam, rhsParam, resultHandle);
    }

    /// @notice              Computes Lt (Less than) operation.
    /// @param metadata      Meta data.
    /// @param lhsParam      LHS parameter.
    /// @param rhsParam      RHS parameter.
    /// @return resultHandle Result handle.
    function Lt(bytes3 metadata, uint256 lhsParam, uint256 rhsParam) public virtual returns (uint256 resultHandle) {
        uint8 lhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ZERO)]);
        uint8 rhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ONE)]);
        bytes1 inputTypes = metadata[uint8(METADATA_INDICES.TWO)];

        // Check that the caller is permitted to access the parameters
        checkACLBinary(lhsParam, rhsParam, inputTypes);

        resultHandle = uint256(keccak256(abi.encodePacked("Lt", lhsParam, rhsParam, metadata)));
        // Permit the calling contract to access the result handle
        acl.permitTransient(resultHandle, msg.sender);

        emit GCBinaryOperation("LT", lhsBitSize, rhsBitSize, inputTypes, lhsParam, rhsParam, resultHandle);
    }

    /// @notice              Computes Ge (Greater than or Equal) operation.
    /// @param metadata      Meta data.
    /// @param lhsParam      LHS parameter.
    /// @param rhsParam      RHS parameter.
    /// @return resultHandle Result handle.
    function Ge(bytes3 metadata, uint256 lhsParam, uint256 rhsParam) public virtual returns (uint256 resultHandle) {
        uint8 lhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ZERO)]);
        uint8 rhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ONE)]);
        bytes1 inputTypes = metadata[uint8(METADATA_INDICES.TWO)];

        // Check that the caller is permitted to access the parameters
        checkACLBinary(lhsParam, rhsParam, inputTypes);

        resultHandle = uint256(keccak256(abi.encodePacked("Ge", lhsParam, rhsParam, metadata)));
        // Permit the calling contract to access the result handle
        acl.permitTransient(resultHandle, msg.sender);

        emit GCBinaryOperation("GE", lhsBitSize, rhsBitSize, inputTypes, lhsParam, rhsParam, resultHandle);
    }

    /// @notice              Computes Gt (Greater than) operation.
    /// @param metadata      Meta data.
    /// @param lhsParam      LHS parameter.
    /// @param rhsParam      RHS parameter.
    /// @return resultHandle Result handle.
    function Gt(bytes3 metadata, uint256 lhsParam, uint256 rhsParam) public virtual returns (uint256 resultHandle) {
        uint8 lhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ZERO)]);
        uint8 rhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ONE)]);
        bytes1 inputTypes = metadata[uint8(METADATA_INDICES.TWO)];

        // Check that the caller is permitted to access the parameters
        checkACLBinary(lhsParam, rhsParam, inputTypes);

        resultHandle = uint256(keccak256(abi.encodePacked("Gt", lhsParam, rhsParam, metadata)));
        // Permit the calling contract to access the result handle
        acl.permitTransient(resultHandle, msg.sender);

        emit GCBinaryOperation("GT", lhsBitSize, rhsBitSize, inputTypes, lhsParam, rhsParam, resultHandle);
    }

    /// @notice              Computes Eq (Equal) operation.
    /// @param metadata      Meta data.
    /// @param lhsParam      LHS parameter.
    /// @param rhsParam      RHS parameter.
    /// @return resultHandle Result handle.
    function Eq(bytes3 metadata, uint256 lhsParam, uint256 rhsParam) public virtual returns (uint256 resultHandle) {
        uint8 lhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ZERO)]);
        uint8 rhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ONE)]);
        bytes1 inputTypes = metadata[uint8(METADATA_INDICES.TWO)];

        // Check that the caller is permitted to access the parameters
        checkACLBinary(lhsParam, rhsParam, inputTypes);

        resultHandle = uint256(keccak256(abi.encodePacked("Eq", lhsParam, rhsParam, metadata)));
        // Permit the calling contract to access the result handle
        acl.permitTransient(resultHandle, msg.sender);

        emit GCBinaryOperation("EQ", lhsBitSize, rhsBitSize, inputTypes, lhsParam, rhsParam, resultHandle);
    }

    /// @notice              Computes Ne (Not Equal) operation.
    /// @param metadata      Meta data.
    /// @param lhsParam      LHS parameter.
    /// @param rhsParam      RHS parameter.
    /// @return resultHandle Result handle.
    function Ne(bytes3 metadata, uint256 lhsParam, uint256 rhsParam) public virtual returns (uint256 resultHandle) {
        uint8 lhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ZERO)]);
        uint8 rhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ONE)]);
        bytes1 inputTypes = metadata[uint8(METADATA_INDICES.TWO)];

        // Check that the caller is permitted to access the parameters
        checkACLBinary(lhsParam, rhsParam, inputTypes);

        resultHandle = uint256(keccak256(abi.encodePacked("Ne", lhsParam, rhsParam, metadata)));
        // Permit the calling contract to access the result handle
        acl.permitTransient(resultHandle, msg.sender);

        emit GCBinaryOperation("NE", lhsBitSize, rhsBitSize, inputTypes, lhsParam, rhsParam, resultHandle);
    }

    /// @notice              Computes Min operation.
    /// @param metadata      Meta data.
    /// @param lhsParam      LHS parameter.
    /// @param rhsParam      RHS parameter.
    /// @return resultHandle Result handle.
    function Min(bytes3 metadata, uint256 lhsParam, uint256 rhsParam) public virtual returns (uint256 resultHandle) {
        uint8 lhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ZERO)]);
        uint8 rhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ONE)]);
        bytes1 inputTypes = metadata[uint8(METADATA_INDICES.TWO)];

        // Check that the caller is permitted to access the parameters
        checkACLBinary(lhsParam, rhsParam, inputTypes);

        resultHandle = uint256(keccak256(abi.encodePacked("Min", lhsParam, rhsParam, metadata)));
        // Permit the calling contract to access the result handle
        acl.permitTransient(resultHandle, msg.sender);

        emit GCBinaryOperation("MIN", lhsBitSize, rhsBitSize, inputTypes, lhsParam, rhsParam, resultHandle);
    }

    /// @notice              Computes Max operation.
    /// @param metadata      Meta data.
    /// @param lhsParam      LHS parameter.
    /// @param rhsParam      RHS parameter.
    /// @return resultHandle Result handle.
    function Max(bytes3 metadata, uint256 lhsParam, uint256 rhsParam) public virtual returns (uint256 resultHandle) {
        uint8 lhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ZERO)]);
        uint8 rhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ONE)]);
        bytes1 inputTypes = metadata[uint8(METADATA_INDICES.TWO)];

        // Check that the caller is permitted to access the parameters
        checkACLBinary(lhsParam, rhsParam, inputTypes);

        resultHandle = uint256(keccak256(abi.encodePacked("Max", lhsParam, rhsParam, metadata)));
        // Permit the calling contract to access the result handle
        acl.permitTransient(resultHandle, msg.sender);

        emit GCBinaryOperation("MAX", lhsBitSize, rhsBitSize, inputTypes, lhsParam, rhsParam, resultHandle);
    }

    /// @notice              Computes Div operation.
    /// @param metadata      Meta data.
    /// @param lhsParam      LHS parameter.
    /// @param rhsParam      RHS parameter.
    /// @return resultHandle Result handle.
    function Div(bytes3 metadata, uint256 lhsParam, uint256 rhsParam) public virtual returns (uint256 resultHandle) {
        uint8 lhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ZERO)]);
        uint8 rhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ONE)]);
        bytes1 inputTypes = metadata[uint8(METADATA_INDICES.TWO)];

        // Check that the caller is permitted to access the parameters
        checkACLBinary(lhsParam, rhsParam, inputTypes);

        resultHandle = uint256(keccak256(abi.encodePacked("Div", lhsParam, rhsParam, metadata)));
        // Permit the calling contract to access the result handle
        acl.permitTransient(resultHandle, msg.sender);

        emit GCBinaryOperation("DIV", lhsBitSize, rhsBitSize, inputTypes, lhsParam, rhsParam, resultHandle);
    }

    /// @notice              Computes Rem (Remainder) operation.
    /// @param metadata      Meta data.
    /// @param lhsParam      LHS parameter.
    /// @param rhsParam      RHS parameter.
    /// @return resultHandle Result handle.
    function Rem(bytes3 metadata, uint256 lhsParam, uint256 rhsParam) public virtual returns (uint256 resultHandle) {
        uint8 lhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ZERO)]);
        uint8 rhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ONE)]);
        bytes1 inputTypes = metadata[uint8(METADATA_INDICES.TWO)];

        // Check that the caller is permitted to access the parameters
        checkACLBinary(lhsParam, rhsParam, inputTypes);

        resultHandle = uint256(keccak256(abi.encodePacked("Rem", lhsParam, rhsParam, metadata)));
        // Permit the calling contract to access the result handle
        acl.permitTransient(resultHandle, msg.sender);

        emit GCBinaryOperation("REM", lhsBitSize, rhsBitSize, inputTypes, lhsParam, rhsParam, resultHandle);
    }

    /// @notice              Computes And operation.
    /// @param metadata      Meta data.
    /// @param lhsParam      LHS parameter.
    /// @param rhsParam      RHS parameter.
    /// @return resultHandle Result handle.
    function And(bytes3 metadata, uint256 lhsParam, uint256 rhsParam) public virtual returns (uint256 resultHandle) {
        uint8 lhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ZERO)]);
        uint8 rhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ONE)]);
        bytes1 inputTypes = metadata[uint8(METADATA_INDICES.TWO)];

        // Check that the caller is permitted to access the parameters
        checkACLBinary(lhsParam, rhsParam, inputTypes);

        resultHandle = uint256(keccak256(abi.encodePacked("And", lhsParam, rhsParam, metadata)));
        // Permit the calling contract to access the result handle
        acl.permitTransient(resultHandle, msg.sender);

        emit GCBinaryOperation("AND", lhsBitSize, rhsBitSize, inputTypes, lhsParam, rhsParam, resultHandle);
    }

    /// @notice              Computes Or operation.
    /// @param metadata      Meta data.
    /// @param lhsParam      LHS parameter.
    /// @param rhsParam      RHS parameter.
    /// @return resultHandle Result handle.
    function Or(bytes3 metadata, uint256 lhsParam, uint256 rhsParam) public virtual returns (uint256 resultHandle) {
        uint8 lhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ZERO)]);
        uint8 rhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ONE)]);
        bytes1 inputTypes = metadata[uint8(METADATA_INDICES.TWO)];

        // Check that the caller is permitted to access the parameters
        checkACLBinary(lhsParam, rhsParam, inputTypes);

        resultHandle = uint256(keccak256(abi.encodePacked("Or", lhsParam, rhsParam, metadata)));
        // Permit the calling contract to access the result handle
        acl.permitTransient(resultHandle, msg.sender);

        emit GCBinaryOperation("OR", lhsBitSize, rhsBitSize, inputTypes, lhsParam, rhsParam, resultHandle);
    }

    /// @notice              Computes Xor operation.
    /// @param metadata      Meta data.
    /// @param lhsParam      LHS parameter.
    /// @param rhsParam      RHS parameter.
    /// @return resultHandle Result handle.
    function Xor(bytes3 metadata, uint256 lhsParam, uint256 rhsParam) public virtual returns (uint256 resultHandle) {
        uint8 lhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ZERO)]);
        uint8 rhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ONE)]);
        bytes1 inputTypes = metadata[uint8(METADATA_INDICES.TWO)];

        // Check that the caller is permitted to access the parameters
        checkACLBinary(lhsParam, rhsParam, inputTypes);

        resultHandle = uint256(keccak256(abi.encodePacked("Xor", lhsParam, rhsParam, metadata)));
        // Permit the calling contract to access the result handle
        acl.permitTransient(resultHandle, msg.sender);

        emit GCBinaryOperation("XOR", lhsBitSize, rhsBitSize, inputTypes, lhsParam, rhsParam, resultHandle);
    }

    /// @notice              Computes Shift Left operation.
    /// @param metadata      Meta data.
    /// @param lhsParam      LHS parameter.
    /// @param rhsParam      RHS parameter.
    /// @return resultHandle Result handle.
    function Shl(bytes3 metadata, uint256 lhsParam, uint256 rhsParam) public virtual returns (uint256 resultHandle) {
        uint8 lhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ZERO)]);
        uint8 rhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ONE)]);
        bytes1 inputTypes = metadata[uint8(METADATA_INDICES.TWO)];

        // Check that the caller is permitted to access the parameters
        checkACLBinary(lhsParam, rhsParam, inputTypes);

        resultHandle = uint256(keccak256(abi.encodePacked("Shl", lhsParam, rhsParam, metadata)));
        // Permit the calling contract to access the result handle
        acl.permitTransient(resultHandle, msg.sender);

        emit GCBinaryOperation("SHL", lhsBitSize, rhsBitSize, inputTypes, lhsParam, rhsParam, resultHandle);
    }

    /// @notice              Computes Shift Right operation.
    /// @param metadata      Meta data.
    /// @param lhsParam      LHS parameter.
    /// @param rhsParam      RHS parameter.
    /// @return resultHandle Result handle.
    function Shr(bytes3 metadata, uint256 lhsParam, uint256 rhsParam) public virtual returns (uint256 resultHandle) {
        uint8 lhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ZERO)]);
        uint8 rhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ONE)]);
        bytes1 inputTypes = metadata[uint8(METADATA_INDICES.TWO)];

        // Check that the caller is permitted to access the parameters
        checkACLBinary(lhsParam, rhsParam, inputTypes);

        resultHandle = uint256(keccak256(abi.encodePacked("Shr", lhsParam, rhsParam, metadata)));
        // Permit the calling contract to access the result handle
        acl.permitTransient(resultHandle, msg.sender);

        emit GCBinaryOperation("SHR", lhsBitSize, rhsBitSize, inputTypes, lhsParam, rhsParam, resultHandle);
    }

    /// @notice              Computes Transfer operation.
    /// @param metadata      Meta data.
    /// @param from          From parameter.
    /// @param to            To parameter.
    /// @param amount        Amount parameter.
    /// @return newFromHandle Result from handle.
    /// @return newToHandle   Result to handle.
    /// @return resultHandle  Result handle.
    function Transfer(bytes4 metadata, uint256 from, uint256 to, uint256 amount) public virtual returns (uint256 newFromHandle, uint256 newToHandle, uint256 resultHandle) {
        uint8 fromBitSize = getSize(metadata[uint8(METADATA_INDICES.ZERO)]);
        uint8 toBitSize = getSize(metadata[uint8(METADATA_INDICES.ONE)]);
        uint8 amountBitSize = getSize(metadata[uint8(METADATA_INDICES.TWO)]);
        bytes1 amountType = metadata[uint8(METADATA_INDICES.THREE)];

        // Check that the caller is permitted to access the parameters
        checkACLBinary(from, to, bytes1(0)); // In transfer both from and to are handles
        if (amountType == bytes1(0)) {
            if (!checkACL(amount)) revert ACLNotPermitted(amount, msg.sender);
        }

        newFromHandle = uint256(keccak256(abi.encodePacked("TransferFrom", from, to, amount, metadata)));
        newToHandle = uint256(keccak256(abi.encodePacked("TransferTo", from, to, amount, metadata)));
        resultHandle = uint256(keccak256(abi.encodePacked("TransferRes", from, to, amount, metadata)));
        // Permit the calling contract to access the result handles
        acl.permitTransient(newFromHandle, msg.sender);
        acl.permitTransient(newToHandle, msg.sender);
        acl.permitTransient(resultHandle, msg.sender);

        emit GCTransfer(fromBitSize, toBitSize, amountBitSize, amountType, from, to, amount, newFromHandle, newToHandle, resultHandle);
    }

    /// @notice              Computes TransferWithAllowance operation.
    /// @param metadata      Meta data.
    /// @param from          From parameter.
    /// @param to            To parameter.
    /// @param amount        Amount parameter.
    /// @param allowance     Allowance parameter.
    /// @return newFromHandle Result from handle.
    /// @return newToHandle   Result to handle.
    /// @return resultHandle  Result handle.
    /// @return newAllowanceHandle Result allowance handle.
    function TransferWithAllowance(bytes5 metadata, uint256 from, uint256 to, uint256 amount, uint256 allowance) public virtual returns (uint256 newFromHandle, uint256 newToHandle, uint256 resultHandle, uint256 newAllowanceHandle) {
        uint8 fromBitSize = getSize(metadata[uint8(METADATA_INDICES.ZERO)]);
        uint8 toBitSize = getSize(metadata[uint8(METADATA_INDICES.ONE)]);
        uint8 amountBitSize = getSize(metadata[uint8(METADATA_INDICES.TWO)]);
        uint8 allowanceBitSize = getSize(metadata[uint8(METADATA_INDICES.THREE)]);
        bytes1 amountType = metadata[uint8(METADATA_INDICES.FOUR)];

        // Check that the caller is permitted to access the parameters
        checkACLBinary(from, to, bytes1(0)); // In transfer both from and to are handles
        if (amountType == bytes1(0)) {
            if (!checkACL(amount)) revert ACLNotPermitted(amount, msg.sender);
        }

        newFromHandle = uint256(keccak256(abi.encodePacked("TransferAllowanceFrom", from, to, amount, allowance, metadata)));
        newToHandle = uint256(keccak256(abi.encodePacked("TransferAllowanceTo", from, to, amount, allowance, metadata)));
        resultHandle = uint256(keccak256(abi.encodePacked("TransferAllowanceRes", from, to, amount, allowance, metadata)));
        newAllowanceHandle = uint256(keccak256(abi.encodePacked("TransferAllowanceAllowance", from, to, amount, allowance, metadata)));
        // Permit the calling contract to access the result handles
        acl.permitTransient(newFromHandle, msg.sender);
        acl.permitTransient(newToHandle, msg.sender);
        acl.permitTransient(resultHandle, msg.sender);
        acl.permitTransient(newAllowanceHandle, msg.sender);

        emit GCTransferWithAllowance(fromBitSize, toBitSize, amountBitSize, allowanceBitSize, amountType, from, to, amount, allowance, newFromHandle, newToHandle, resultHandle, newAllowanceHandle);
    }

    /// @notice              Computes Mux operation.
    /// @param metadata      Meta data.
    /// @param bitParam  Bit parameter.
    /// @param lhsParam  LHS parameter.
    /// @param rhsParam  RHS parameter.
    /// @return resultHandle Result handle.
    function Mux(bytes3 metadata, uint256 bitParam, uint256 lhsParam, uint256 rhsParam) public virtual returns (uint256 resultHandle) {
        // TODO implement checks on the input
        uint8 lhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ZERO)]);
        uint8 rhsBitSize = getSize(metadata[uint8(METADATA_INDICES.ONE)]);
        bytes1 inputTypes = metadata[uint8(METADATA_INDICES.TWO)];

        // Check that the caller is permitted to access the parameters
        checkACLBinary(lhsParam, rhsParam, inputTypes);

        resultHandle = uint256(keccak256(abi.encodePacked("Mux", bitParam, lhsParam, rhsParam, metadata)));
        // Permit the calling contract to access the result handle
        acl.permitTransient(resultHandle, msg.sender);

        emit GCMux(lhsBitSize, rhsBitSize, inputTypes, bitParam, lhsParam, rhsParam, resultHandle);
    }

    /// @notice              Computes SetPublic operation.
    /// @param metadata      Meta data.
    /// @param param         Parameter.
    /// @return result       Result handle.
    function SetPublic(bytes1 metadata, uint256 param) public virtual returns (uint256 result){
        uint8 bitSize = getSize(metadata[uint8(METADATA_INDICES.ZERO)]);
        result = uint256(keccak256(abi.encodePacked("SetPublic", param, metadata)));
        // Permit the calling contract to access the result handle
        acl.permitTransient(result, msg.sender);

        emit GCUnaryOperation("SETPUBLIC", bitSize, param, result);
    }

    /// @notice              Computes Not operation.
    /// @param metadata      Meta data.
    /// @param param         Parameter.
    /// @return result       Result handle.
    function Not(bytes1 metadata, uint256 param) public virtual returns (uint256 result){
        // Check that the caller is permitted to access the parameter
        if (!checkACL(param)) revert ACLNotPermitted(param, msg.sender);

        uint8 bitSize = getSize(metadata[uint8(METADATA_INDICES.ZERO)]);
        result = uint256(keccak256(abi.encodePacked("Not", param, metadata)));
        // Permit the calling contract to access the result handle
        acl.permitTransient(result, msg.sender);

        emit GCUnaryOperation("NOT", bitSize, param, result);
    }

    /// @notice                 Computes RequestDecryption operation.
    /// @param decryptID        Decrypt ID.
    /// @param handles          Handles to decrypt.
    /// @param callbackSelector Callback selector.
    function RequestDecryption(uint256 decryptID, uint256[] calldata handles, bytes4 callbackSelector) public virtual {
        // Check that the caller is permitted to access the parameter
        for (uint256 i = 0; i < handles.length; i++) {
            if (!checkACL(handles[i])) revert ACLNotPermitted(handles[i], msg.sender);
        }

        emit GCDecryptionRequest(decryptionOracleStorage.counter, decryptID, handles, msg.sender, callbackSelector);
        decryptionOracleStorage.counter++;
    }

    /// @notice              Returns the message that should be signed for ValidateCiphertext.
    /// @param ciphertext    Ciphertext to validate.
    /// @return             The message that should be signed.
    function GetMessageToSign(uint256 ciphertext) public view returns (bytes memory) {
        return abi.encodePacked(tx.origin, msg.sender, ciphertext);
    }

    /// @notice              Computes ValidateCiphertext operation.
    /// @param metadata      Meta data.
    /// @param ciphertext    Ciphertext to validate.
    /// @param signature     Signature of the ciphertext.
    /// @return result       Result handle.
    function ValidateCiphertext(bytes1 metadata, uint256 ciphertext, bytes calldata signature) public virtual returns (uint256 result){
        // check if the signature is valid
        if (signature.length != 65) {
            revert InvalidSignature();
        }

        // Create message of the signature: user address + contract address + ciphertext
        bytes memory message = abi.encodePacked(tx.origin, msg.sender, ciphertext);
        bytes32 messageHash = keccak256(message);

        uint8 v = uint8(signature[64]);
        if ( v < 27) {
            v += 27; // Need to adjust v to be 27/28
        }

        // Recover the address from the message hash
        address recoveredAddress = ecrecover(messageHash, v, bytes32(signature[:32]), bytes32(signature[32:64]));

        // check if the recovered address is the same as the tx origin
        if (recoveredAddress != tx.origin) {
            // Failed to validate the signature, Try to recover with eip191
            // Update the message to include the eip 191 prefix, message length, and the message
            bytes32 ethSignedMessageHash = MessageHashUtils.toEthSignedMessageHash(message);

            // Recover the address from the prefixed hash
            recoveredAddress = ecrecover(ethSignedMessageHash, v, bytes32(signature[:32]), bytes32(signature[32:64]));

            // check if the recovered address is the same as the tx origin
            if (recoveredAddress != tx.origin) {
                // Failed to validate the signature, revert
                revert InvalidSignature();
            }
        }

        // Signer is valid, onboard the ct
        uint8 bitSize = getSize(metadata[uint8(METADATA_INDICES.ZERO)]);
        result = uint256(keccak256(abi.encodePacked("Onboard", ciphertext, tx.origin, metadata)));
        // Permit the calling contract to access the result handle
        // acl.permitTransient(result, msg.sender);

        emit GCOnboard(bitSize, ciphertext, tx.origin, result);
    }

    /// @notice              Computes Rand operation.
    /// @param metadata      Meta data.
    /// @return result       Result handle.
    function Rand(bytes1 metadata) public virtual returns (uint256 result){
        uint8 bitSize = getSize(metadata[uint8(METADATA_INDICES.ZERO)]);
        // The randStorage.counter is used to avoid collisions in the result handles
        // when there are multiple calls to the Rand function.
        result = uint256(keccak256(abi.encodePacked("Rand", randStorage.counter, metadata)));
        // Permit the calling contract to access the result handle
        acl.permitTransient(result, msg.sender);

        emit GCRand(bitSize, result);
        randStorage.counter++;
    }

    /// @notice              Computes RandBoundedBits operation.
    /// @param metadata      Meta data.
    /// @param numBits       Number of bits to generate.
    /// @return result       Result handle.
    function RandBoundedBits(bytes1 metadata, uint8 numBits) public virtual returns (uint256 result){
        uint8 bitSize = getSize(metadata[uint8(METADATA_INDICES.ZERO)]);
        // The randStorage.counter is used to avoid collisions in the result handles
        // when there are multiple calls to the Rand function.
        result = uint256(keccak256(abi.encodePacked("RandBoundedBits", randStorage.counter, numBits, metadata)));
        // Permit the calling contract to access the result handle
        acl.permitTransient(result, msg.sender);

        emit GCUnaryOperation("RAND", bitSize, numBits, result);
        randStorage.counter++;
    }
        
}
