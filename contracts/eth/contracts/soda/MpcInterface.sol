// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface GCExtendedOperations {
    function SetPublic(bytes1 metaData, uint256 ct) external returns (uint256 result);
    function Rand(bytes1 metaData) external returns (uint256 result);
    function RandBoundedBits(bytes1 metaData, uint8 numBits) external returns (uint256 result);
    function Add(bytes3 metaData, uint256 lhs, uint256 rhs) external returns (uint256 result);
    function CheckedAdd(
        bytes3 metaData,
        uint256 lhs,
        uint256 rhs
    ) external returns (uint256 overflowBit, uint256 result);
    function Sub(bytes3 metaData, uint256 lhs, uint256 rhs) external returns (uint256 result);
    function CheckedSub(
        bytes3 metaData,
        uint256 lhs,
        uint256 rhs
    ) external returns (uint256 overflowBit, uint256 result);
    function Mul(bytes3 metaData, uint256 lhs, uint256 rhs) external returns (uint256 result);
    function CheckedMul(
        bytes3 metaData,
        uint256 lhs,
        uint256 rhs
    ) external returns (uint256 overflowBit, uint256 result);
    function Div(bytes3 metaData, uint256 lhs, uint256 rhs) external returns (uint256 result);
    function Rem(bytes3 metaData, uint256 lhs, uint256 rhs) external returns (uint256 result);
    function And(bytes3 metaData, uint256 lhs, uint256 rhs) external returns (uint256 result);
    function Or(bytes3 metaData, uint256 lhs, uint256 rhs) external returns (uint256 result);
    function Xor(bytes3 metaData, uint256 lhs, uint256 rhs) external returns (uint256 result);
    function Shl(bytes3 metaData, uint256 lhs, uint256 rhs) external returns (uint256 result);
    function Shr(bytes3 metaData, uint256 lhs, uint256 rhs) external returns (uint256 result);
    function Eq(bytes3 metaData, uint256 lhs, uint256 rhs) external returns (uint256 result);
    function Ne(bytes3 metaData, uint256 lhs, uint256 rhs) external returns (uint256 result);
    function Ge(bytes3 metaData, uint256 lhs, uint256 rhs) external returns (uint256 result);
    function Gt(bytes3 metaData, uint256 lhs, uint256 rhs) external returns (uint256 result);
    function Le(bytes3 metaData, uint256 lhs, uint256 rhs) external returns (uint256 result);
    function Lt(bytes3 metaData, uint256 lhs, uint256 rhs) external returns (uint256 result);
    function Min(bytes3 metaData, uint256 lhs, uint256 rhs) external returns (uint256 result);
    function Max(bytes3 metaData, uint256 lhs, uint256 rhs) external returns (uint256 result);
    function Mux(bytes3 metaData, uint256 bit, uint256 a, uint256 b) external returns (uint256 result);
    function Not(bytes1 metaData, uint256 a) external returns (uint256 result);
    function Transfer(
        bytes4 metaData,
        uint256 from,
        uint256 to,
        uint256 amount
    ) external returns (uint256 new_from, uint256 new_to, uint256 res);
    function TransferWithAllowance(
        bytes5 metaData,
        uint256 from,
        uint256 to,
        uint256 amount,
        uint256 allowance
    ) external returns (uint256 new_from, uint256 new_to, uint256 res, uint256 new_allowance);
    function ValidateCiphertext(
        bytes1 metaData,
        uint256 ciphertext,
        bytes calldata signature
    ) external returns (uint256 result);
    function RequestDecryption(uint256 decryptID, uint256[] calldata handles, bytes4 callbackSelector) external;
}

interface GCACL {
    function permit(uint256 handle, address account) external;
    function permitTransient(uint256 handle, address account) external;
    function isPermitted(uint256 handle, address account) external view returns (bool);
    function isPermittedTransient(uint256 handle, address account) external view returns (bool);
    function isPermittedPersistent(uint256 handle, address account) external view returns (bool);
}
