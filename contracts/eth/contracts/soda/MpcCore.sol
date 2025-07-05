// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

type gtBool is uint256;
type gtUint8 is uint256;
type gtUint16 is uint256;
type gtUint32 is uint256;
type gtUint64 is uint256;

type ctBool is uint256;
type ctUint8 is uint256;
type ctUint16 is uint256;
type ctUint32 is uint256;
type ctUint64 is uint256;

struct itBool {
    ctBool ciphertext;
    bytes signature;
}
struct itUint8 {
    ctUint8 ciphertext;
    bytes signature;
}
struct itUint16 {
    ctUint16 ciphertext;
    bytes signature;
}
struct itUint32 {
    ctUint32 ciphertext;
    bytes signature;
}
struct itUint64 {
    ctUint64 ciphertext;
    bytes signature;
}

import "./MpcInterface.sol";
import "./GCHandlerAddress.sol";
import "./GCACLAddress.sol";

library MpcCore {
    enum MPC_TYPE {
        SBOOL_T,
        SUINT8_T,
        SUINT16_T,
        SUINT32_T,
        SUINT64_T
    }
    enum ARGS {
        BOTH_SECRET,
        LHS_PUBLIC,
        RHS_PUBLIC
    }
    uint public constant RSA_SIZE = 256;

    function combineEnumsToBytes2(MPC_TYPE mpcType, ARGS argsType) internal pure returns (bytes2) {
        return bytes2((uint16(mpcType) << 8) | uint8(argsType));
    }

    function combineEnumsToBytes3(MPC_TYPE mpcType1, MPC_TYPE mpcType2, ARGS argsType) internal pure returns (bytes3) {
        return bytes3((uint24(mpcType1) << 16) | (uint16(mpcType2) << 8) | uint8(argsType));
    }

    function combineEnumsToBytes4(
        MPC_TYPE mpcType1,
        MPC_TYPE mpcType2,
        MPC_TYPE mpcType3,
        ARGS argsType
    ) internal pure returns (bytes4) {
        return bytes4((uint32(mpcType1) << 24) | (uint24(mpcType2) << 16) | (uint16(mpcType3) << 8) | uint8(argsType));
    }

    function combineEnumsToBytes5(
        MPC_TYPE mpcType1,
        MPC_TYPE mpcType2,
        MPC_TYPE mpcType3,
        MPC_TYPE mpcType4,
        ARGS argsType
    ) internal pure returns (bytes5) {
        return
            bytes5(
                (uint40(mpcType1) << 32) |
                    (uint32(mpcType2) << 24) |
                    (uint24(mpcType3) << 16) |
                    (uint16(mpcType4) << 8) |
                    uint8(argsType)
            );
    }

    function requestDecryption(uint256 decryptID, uint256[] memory handles, bytes4 callbackSelector) internal {
        GCExtendedOperations(address(GCExtendedOperationsAddress)).RequestDecryption(
            decryptID,
            handles,
            callbackSelector
        );
    }

    function permit(gtBool handle, address account) internal {
        GCACL(address(GCACLAddress)).permit(gtBool.unwrap(handle), account);
    }

    function permit(gtUint8 handle, address account) internal {
        GCACL(address(GCACLAddress)).permit(gtUint8.unwrap(handle), account);
    }

    function permit(gtUint16 handle, address account) internal {
        GCACL(address(GCACLAddress)).permit(gtUint16.unwrap(handle), account);
    }

    function permit(gtUint32 handle, address account) internal {
        GCACL(address(GCACLAddress)).permit(gtUint32.unwrap(handle), account);
    }

    function permit(gtUint64 handle, address account) internal {
        GCACL(address(GCACLAddress)).permit(gtUint64.unwrap(handle), account);
    }

    function permitThis(gtBool handle) internal {
        GCACL(address(GCACLAddress)).permit(gtBool.unwrap(handle), address(this));
    }

    function permitThis(gtUint8 handle) internal {
        GCACL(address(GCACLAddress)).permit(gtUint8.unwrap(handle), address(this));
    }

    function permitThis(gtUint16 handle) internal {
        GCACL(address(GCACLAddress)).permit(gtUint16.unwrap(handle), address(this));
    }

    function permitThis(gtUint32 handle) internal {
        GCACL(address(GCACLAddress)).permit(gtUint32.unwrap(handle), address(this));
    }

    function permitThis(gtUint64 handle) internal {
        GCACL(address(GCACLAddress)).permit(gtUint64.unwrap(handle), address(this));
    }

    function permitTransient(gtBool handle, address account) internal {
        GCACL(address(GCACLAddress)).permitTransient(gtBool.unwrap(handle), account);
    }

    function permitTransient(gtUint8 handle, address account) internal {
        GCACL(address(GCACLAddress)).permitTransient(gtUint8.unwrap(handle), account);
    }

    function permitTransient(gtUint16 handle, address account) internal {
        GCACL(address(GCACLAddress)).permitTransient(gtUint16.unwrap(handle), account);
    }

    function permitTransient(gtUint32 handle, address account) internal {
        GCACL(address(GCACLAddress)).permitTransient(gtUint32.unwrap(handle), account);
    }

    function permitTransient(gtUint64 handle, address account) internal {
        GCACL(address(GCACLAddress)).permitTransient(gtUint64.unwrap(handle), account);
    }

    function isSenderPermitted(gtBool handle) internal view returns (bool) {
        return isPermitted(handle, msg.sender);
    }

    function isSenderPermitted(gtUint8 handle) internal view returns (bool) {
        return isPermitted(handle, msg.sender);
    }

    function isSenderPermitted(gtUint16 handle) internal view returns (bool) {
        return isPermitted(handle, msg.sender);
    }

    function isSenderPermitted(gtUint32 handle) internal view returns (bool) {
        return isPermitted(handle, msg.sender);
    }

    function isSenderPermitted(gtUint64 handle) internal view returns (bool) {
        return isPermitted(handle, msg.sender);
    }

    function isPermitted(gtBool handle, address account) internal view returns (bool) {
        return GCACL(address(GCACLAddress)).isPermitted(gtBool.unwrap(handle), account);
    }

    function isPermitted(gtUint8 handle, address account) internal view returns (bool) {
        return GCACL(address(GCACLAddress)).isPermitted(gtUint8.unwrap(handle), account);
    }

    function isPermitted(gtUint16 handle, address account) internal view returns (bool) {
        return GCACL(address(GCACLAddress)).isPermitted(gtUint16.unwrap(handle), account);
    }

    function isPermitted(gtUint32 handle, address account) internal view returns (bool) {
        return GCACL(address(GCACLAddress)).isPermitted(gtUint32.unwrap(handle), account);
    }

    function isPermitted(gtUint64 handle, address account) internal view returns (bool) {
        return GCACL(address(GCACLAddress)).isPermitted(gtUint64.unwrap(handle), account);
    }

    function isPermittedTransient(gtBool handle, address account) internal view returns (bool) {
        return GCACL(address(GCACLAddress)).isPermittedTransient(gtBool.unwrap(handle), account);
    }

    function isPermittedTransient(gtUint8 handle, address account) internal view returns (bool) {
        return GCACL(address(GCACLAddress)).isPermittedTransient(gtUint8.unwrap(handle), account);
    }

    function isPermittedTransient(gtUint16 handle, address account) internal view returns (bool) {
        return GCACL(address(GCACLAddress)).isPermittedTransient(gtUint16.unwrap(handle), account);
    }

    function isPermittedTransient(gtUint32 handle, address account) internal view returns (bool) {
        return GCACL(address(GCACLAddress)).isPermittedTransient(gtUint32.unwrap(handle), account);
    }

    function isPermittedTransient(gtUint64 handle, address account) internal view returns (bool) {
        return GCACL(address(GCACLAddress)).isPermittedTransient(gtUint64.unwrap(handle), account);
    }

    function isPermittedPersistent(gtBool handle, address account) internal view returns (bool) {
        return GCACL(address(GCACLAddress)).isPermittedPersistent(gtBool.unwrap(handle), account);
    }

    function isPermittedPersistent(gtUint8 handle, address account) internal view returns (bool) {
        return GCACL(address(GCACLAddress)).isPermittedPersistent(gtUint8.unwrap(handle), account);
    }

    function isPermittedPersistent(gtUint16 handle, address account) internal view returns (bool) {
        return GCACL(address(GCACLAddress)).isPermittedPersistent(gtUint16.unwrap(handle), account);
    }

    function isPermittedPersistent(gtUint32 handle, address account) internal view returns (bool) {
        return GCACL(address(GCACLAddress)).isPermittedPersistent(gtUint32.unwrap(handle), account);
    }

    function isPermittedPersistent(gtUint64 handle, address account) internal view returns (bool) {
        return GCACL(address(GCACLAddress)).isPermittedPersistent(gtUint64.unwrap(handle), account);
    }

    // =========== 1 bit operations ==============

    function validateCiphertext(itBool memory input) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).ValidateCiphertext(
                    bytes1(uint8(MPC_TYPE.SBOOL_T)),
                    ctBool.unwrap(input.ciphertext),
                    input.signature
                )
            );
    }

    function setPublic(bool pt) internal returns (gtBool) {
        uint256 temp;
        temp = pt ? 1 : 0;
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).SetPublic(
                    bytes1(uint8(MPC_TYPE.SBOOL_T)),
                    temp
                )
            );
    }

    function rand() internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Rand(bytes1(uint8(MPC_TYPE.SBOOL_T)))
            );
    }

    function and(gtBool a, gtBool b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).And(
                    combineEnumsToBytes3(MPC_TYPE.SBOOL_T, MPC_TYPE.SBOOL_T, ARGS.BOTH_SECRET),
                    gtBool.unwrap(a),
                    gtBool.unwrap(b)
                )
            );
    }

    function or(gtBool a, gtBool b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Or(
                    combineEnumsToBytes3(MPC_TYPE.SBOOL_T, MPC_TYPE.SBOOL_T, ARGS.BOTH_SECRET),
                    gtBool.unwrap(a),
                    gtBool.unwrap(b)
                )
            );
    }

    function xor(gtBool a, gtBool b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Xor(
                    combineEnumsToBytes3(MPC_TYPE.SBOOL_T, MPC_TYPE.SBOOL_T, ARGS.BOTH_SECRET),
                    gtBool.unwrap(a),
                    gtBool.unwrap(b)
                )
            );
    }

    function eq(gtBool a, gtBool b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Eq(
                    combineEnumsToBytes3(MPC_TYPE.SBOOL_T, MPC_TYPE.SBOOL_T, ARGS.BOTH_SECRET),
                    gtBool.unwrap(a),
                    gtBool.unwrap(b)
                )
            );
    }

    function ne(gtBool a, gtBool b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ne(
                    combineEnumsToBytes3(MPC_TYPE.SBOOL_T, MPC_TYPE.SBOOL_T, ARGS.BOTH_SECRET),
                    gtBool.unwrap(a),
                    gtBool.unwrap(b)
                )
            );
    }

    function mux(gtBool bit, gtBool a, gtBool b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mux(
                    combineEnumsToBytes3(MPC_TYPE.SBOOL_T, MPC_TYPE.SBOOL_T, ARGS.BOTH_SECRET),
                    gtBool.unwrap(bit),
                    gtBool.unwrap(a),
                    gtBool.unwrap(b)
                )
            );
    }

    function not(gtBool a) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Not(
                    bytes1(uint8(MPC_TYPE.SBOOL_T)),
                    gtBool.unwrap(a)
                )
            );
    }

    // =========== Operations with BOTH_SECRET parameter ===========
    // =========== 8 bit operations ==============

    function validateCiphertext(itUint8 memory input) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).ValidateCiphertext(
                    bytes1(uint8(MPC_TYPE.SUINT8_T)),
                    ctUint8.unwrap(input.ciphertext),
                    input.signature
                )
            );
    }

    function setPublic8(uint8 pt) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).SetPublic(
                    bytes1(uint8(MPC_TYPE.SUINT8_T)),
                    uint256(pt)
                )
            );
    }

    function rand8() internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Rand(bytes1(uint8(MPC_TYPE.SUINT8_T)))
            );
    }

    function randBoundedBits8(uint8 numBits) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).RandBoundedBits(
                    bytes1(uint8(MPC_TYPE.SUINT8_T)),
                    numBits
                )
            );
    }

    function add(gtUint8 a, gtUint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Add(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function checkedAddWithOverflowBit(gtUint8 a, gtUint8 b) internal returns (gtBool, gtUint8) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedAdd(
            combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
            gtUint8.unwrap(a),
            gtUint8.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint8.wrap(res));
    }

    function sub(gtUint8 a, gtUint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Sub(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function checkedSubWithOverflowBit(gtUint8 a, gtUint8 b) internal returns (gtBool, gtUint8) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedSub(
            combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
            gtUint8.unwrap(a),
            gtUint8.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint8.wrap(res));
    }

    function mul(gtUint8 a, gtUint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mul(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function checkedMulWithOverflowBit(gtUint8 a, gtUint8 b) internal returns (gtBool, gtUint8) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedMul(
            combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
            gtUint8.unwrap(a),
            gtUint8.unwrap(b)
        );
        return (gtBool.wrap(bit), gtUint8.wrap(res));
    }

    function div(gtUint8 a, gtUint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Div(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function rem(gtUint8 a, gtUint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Rem(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function and(gtUint8 a, gtUint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).And(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function or(gtUint8 a, gtUint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Or(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function xor(gtUint8 a, gtUint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Xor(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function eq(gtUint8 a, gtUint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Eq(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function ne(gtUint8 a, gtUint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ne(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function ge(gtUint8 a, gtUint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ge(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function gt(gtUint8 a, gtUint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Gt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function le(gtUint8 a, gtUint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Le(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function lt(gtUint8 a, gtUint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Lt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function min(gtUint8 a, gtUint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Min(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function max(gtUint8 a, gtUint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Max(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function mux(gtBool bit, gtUint8 a, gtUint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mux(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtBool.unwrap(bit),
                    gtUint8.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function transfer(gtUint8 a, gtUint8 b, gtUint8 amount) internal returns (gtUint8, gtUint8, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                gtUint8.unwrap(a),
                gtUint8.unwrap(b),
                gtUint8.unwrap(amount)
            );
        return (gtUint8.wrap(new_a), gtUint8.wrap(new_b), gtBool.wrap(res));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint8 b,
        gtUint8 amount,
        gtUint8 allowance
    ) internal returns (gtUint8, gtUint8, gtBool, gtUint8) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint8.unwrap(a),
                gtUint8.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint8.wrap(new_a), gtUint8.wrap(new_b), gtBool.wrap(res), gtUint8.wrap(new_allowance));
    }

    // =========== 16 bit operations ==============

    function validateCiphertext(itUint16 memory input) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).ValidateCiphertext(
                    bytes1(uint8(MPC_TYPE.SUINT16_T)),
                    ctUint16.unwrap(input.ciphertext),
                    input.signature
                )
            );
    }

    function setPublic16(uint16 pt) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).SetPublic(
                    bytes1(uint8(MPC_TYPE.SUINT16_T)),
                    uint256(pt)
                )
            );
    }

    function rand16() internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Rand(bytes1(uint8(MPC_TYPE.SUINT16_T)))
            );
    }

    function randBoundedBits16(uint8 numBits) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).RandBoundedBits(
                    bytes1(uint8(MPC_TYPE.SUINT16_T)),
                    numBits
                )
            );
    }

    function add(gtUint16 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Add(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function checkedAddWithOverflowBit(gtUint16 a, gtUint16 b) internal returns (gtBool, gtUint16) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedAdd(
            combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
            gtUint16.unwrap(a),
            gtUint16.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint16.wrap(res));
    }

    function sub(gtUint16 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Sub(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function checkedSubWithOverflowBit(gtUint16 a, gtUint16 b) internal returns (gtBool, gtUint16) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedSub(
            combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
            gtUint16.unwrap(a),
            gtUint16.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint16.wrap(res));
    }

    function mul(gtUint16 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mul(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function checkedMulWithOverflowBit(gtUint16 a, gtUint16 b) internal returns (gtBool, gtUint16) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedMul(
            combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
            gtUint16.unwrap(a),
            gtUint16.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint16.wrap(res));
    }

    function div(gtUint16 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Div(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function rem(gtUint16 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Rem(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function and(gtUint16 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).And(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function or(gtUint16 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Or(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function xor(gtUint16 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Xor(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function eq(gtUint16 a, gtUint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Eq(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function ne(gtUint16 a, gtUint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ne(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function ge(gtUint16 a, gtUint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ge(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function gt(gtUint16 a, gtUint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Gt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function le(gtUint16 a, gtUint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Le(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function lt(gtUint16 a, gtUint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Lt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }
    function min(gtUint16 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Min(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function max(gtUint16 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Max(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function mux(gtBool bit, gtUint16 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mux(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtBool.unwrap(bit),
                    gtUint16.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function transfer(gtUint16 a, gtUint16 b, gtUint16 amount) internal returns (gtUint16, gtUint16, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                gtUint16.unwrap(a),
                gtUint16.unwrap(b),
                gtUint16.unwrap(amount)
            );
        return (gtUint16.wrap(new_a), gtUint16.wrap(new_b), gtBool.wrap(res));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint16 b,
        gtUint16 amount,
        gtUint16 allowance
    ) internal returns (gtUint16, gtUint16, gtBool, gtUint16) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint16.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint16.wrap(new_a), gtUint16.wrap(new_b), gtBool.wrap(res), gtUint16.wrap(new_allowance));
    }

    // =========== 32 bit operations ==============

    function validateCiphertext(itUint32 memory input) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).ValidateCiphertext(
                    bytes1(uint8(MPC_TYPE.SUINT32_T)),
                    ctUint32.unwrap(input.ciphertext),
                    input.signature
                )
            );
    }

    function setPublic32(uint32 pt) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).SetPublic(
                    bytes1(uint8(MPC_TYPE.SUINT32_T)),
                    uint256(pt)
                )
            );
    }

    function rand32() internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Rand(bytes1(uint8(MPC_TYPE.SUINT32_T)))
            );
    }

    function randBoundedBits32(uint8 numBits) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).RandBoundedBits(
                    bytes1(uint8(MPC_TYPE.SUINT32_T)),
                    numBits
                )
            );
    }

    function add(gtUint32 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Add(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function checkedAddWithOverflowBit(gtUint32 a, gtUint32 b) internal returns (gtBool, gtUint32) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedAdd(
            combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
            gtUint32.unwrap(a),
            gtUint32.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint32.wrap(res));
    }

    function sub(gtUint32 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Sub(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function checkedSubWithOverflowBit(gtUint32 a, gtUint32 b) internal returns (gtBool, gtUint32) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedSub(
            combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
            gtUint32.unwrap(a),
            gtUint32.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint32.wrap(res));
    }

    function mul(gtUint32 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mul(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function checkedMulWithOverflowBit(gtUint32 a, gtUint32 b) internal returns (gtBool, gtUint32) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedMul(
            combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
            gtUint32.unwrap(a),
            gtUint32.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint32.wrap(res));
    }

    function div(gtUint32 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Div(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function rem(gtUint32 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Rem(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function and(gtUint32 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).And(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function or(gtUint32 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Or(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function xor(gtUint32 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Xor(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function eq(gtUint32 a, gtUint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Eq(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function ne(gtUint32 a, gtUint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ne(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function ge(gtUint32 a, gtUint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ge(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function gt(gtUint32 a, gtUint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Gt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function le(gtUint32 a, gtUint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Le(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function lt(gtUint32 a, gtUint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Lt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function min(gtUint32 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Min(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function max(gtUint32 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Max(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function mux(gtBool bit, gtUint32 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mux(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtBool.unwrap(bit),
                    gtUint32.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function transfer(gtUint32 a, gtUint32 b, gtUint32 amount) internal returns (gtUint32, gtUint32, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                gtUint32.unwrap(a),
                gtUint32.unwrap(b),
                gtUint32.unwrap(amount)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint32 b,
        gtUint32 amount,
        gtUint32 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint32.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    // =========== 64 bit operations ==============

    function validateCiphertext(itUint64 memory input) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).ValidateCiphertext(
                    bytes1(uint8(MPC_TYPE.SUINT64_T)),
                    ctUint64.unwrap(input.ciphertext),
                    input.signature
                )
            );
    }

    function setPublic64(uint64 pt) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).SetPublic(
                    bytes1(uint8(MPC_TYPE.SUINT64_T)),
                    uint256(pt)
                )
            );
    }

    function rand64() internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Rand(bytes1(uint8(MPC_TYPE.SUINT64_T)))
            );
    }

    function randBoundedBits64(uint8 numBits) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).RandBoundedBits(
                    bytes1(uint8(MPC_TYPE.SUINT64_T)),
                    numBits
                )
            );
    }

    function add(gtUint64 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Add(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function checkedAddWithOverflowBit(gtUint64 a, gtUint64 b) internal returns (gtBool, gtUint64) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedAdd(
            combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
            gtUint64.unwrap(a),
            gtUint64.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint64.wrap(res));
    }

    function sub(gtUint64 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Sub(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function checkedSubWithOverflowBit(gtUint64 a, gtUint64 b) internal returns (gtBool, gtUint64) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedSub(
            combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
            gtUint64.unwrap(a),
            gtUint64.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint64.wrap(res));
    }

    function mul(gtUint64 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mul(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function checkedMulWithOverflowBit(gtUint64 a, gtUint64 b) internal returns (gtBool, gtUint64) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedMul(
            combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
            gtUint64.unwrap(a),
            gtUint64.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint64.wrap(res));
    }

    function div(gtUint64 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Div(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function rem(gtUint64 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Rem(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function and(gtUint64 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).And(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function or(gtUint64 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Or(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function xor(gtUint64 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Xor(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function eq(gtUint64 a, gtUint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Eq(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function ne(gtUint64 a, gtUint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ne(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function ge(gtUint64 a, gtUint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ge(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function gt(gtUint64 a, gtUint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Gt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function le(gtUint64 a, gtUint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Le(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function lt(gtUint64 a, gtUint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Lt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function min(gtUint64 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Min(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function max(gtUint64 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Max(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function mux(gtBool bit, gtUint64 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mux(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtBool.unwrap(bit),
                    gtUint64.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function transfer(gtUint64 a, gtUint64 b, gtUint64 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                gtUint64.unwrap(a),
                gtUint64.unwrap(b),
                gtUint64.unwrap(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint64 b,
        gtUint64 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint64.unwrap(b),
                gtUint64.unwrap(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    // =========== Operations with LHS_PUBLIC parameter ===========
    // =========== 8 bit operations ==============

    function add(uint8 a, gtUint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Add(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function checkedAddWithOverflowBit(uint8 a, gtUint8 b) internal returns (gtBool, gtUint8) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedAdd(
            combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.LHS_PUBLIC),
            uint256(a),
            gtUint8.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint8.wrap(res));
    }

    function sub(uint8 a, gtUint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Sub(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function checkedSubWithOverflowBit(uint8 a, gtUint8 b) internal returns (gtBool, gtUint8) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedSub(
            combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.LHS_PUBLIC),
            uint256(a),
            gtUint8.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint8.wrap(res));
    }

    function mul(uint8 a, gtUint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mul(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function checkedMulWithOverflowBit(uint8 a, gtUint8 b) internal returns (gtBool, gtUint8) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedMul(
            combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.LHS_PUBLIC),
            uint256(a),
            gtUint8.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint8.wrap(res));
    }

    function div(uint8 a, gtUint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Div(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint8.unwrap(b)
                )
            );
    }
    function rem(uint8 a, gtUint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Rem(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function and(uint8 a, gtUint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).And(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function or(uint8 a, gtUint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Or(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function xor(uint8 a, gtUint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Xor(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function eq(uint8 a, gtUint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Eq(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function ne(uint8 a, gtUint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ne(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function ge(uint8 a, gtUint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ge(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function gt(uint8 a, gtUint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Gt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function le(uint8 a, gtUint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Le(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function lt(uint8 a, gtUint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Lt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function min(uint8 a, gtUint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Min(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function max(uint8 a, gtUint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Max(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function mux(gtBool bit, uint8 a, gtUint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mux(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.LHS_PUBLIC),
                    gtBool.unwrap(bit),
                    uint256(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    // =========== 16 bit operations ==============

    function add(uint16 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Add(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function checkedAddWithOverflowBit(uint16 a, gtUint16 b) internal returns (gtBool, gtUint16) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedAdd(
            combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.LHS_PUBLIC),
            uint256(a),
            gtUint16.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint16.wrap(res));
    }

    function sub(uint16 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Sub(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function checkedSubWithOverflowBit(uint16 a, gtUint16 b) internal returns (gtBool, gtUint16) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedSub(
            combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.LHS_PUBLIC),
            uint256(a),
            gtUint16.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint16.wrap(res));
    }

    function mul(uint16 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mul(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function checkedMulWithOverflowBit(uint16 a, gtUint16 b) internal returns (gtBool, gtUint16) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedMul(
            combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.LHS_PUBLIC),
            uint256(a),
            gtUint16.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint16.wrap(res));
    }

    function div(uint16 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Div(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function rem(uint16 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Rem(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function and(uint16 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).And(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function or(uint16 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Or(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function xor(uint16 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Xor(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function eq(uint16 a, gtUint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Eq(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function ne(uint16 a, gtUint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ne(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function ge(uint16 a, gtUint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ge(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function gt(uint16 a, gtUint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Gt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function le(uint16 a, gtUint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Le(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function lt(uint16 a, gtUint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Lt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function min(uint16 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Min(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function max(uint16 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Max(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function mux(gtBool bit, uint16 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mux(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.LHS_PUBLIC),
                    gtBool.unwrap(bit),
                    uint256(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    // =========== 32 bit operations ==============

    function add(uint32 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Add(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function checkedAddWithOverflowBit(uint32 a, gtUint32 b) internal returns (gtBool, gtUint32) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedAdd(
            combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.LHS_PUBLIC),
            uint256(a),
            gtUint32.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint32.wrap(res));
    }

    function sub(uint32 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Sub(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function checkedSubWithOverflowBit(uint32 a, gtUint32 b) internal returns (gtBool, gtUint32) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedSub(
            combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.LHS_PUBLIC),
            uint256(a),
            gtUint32.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint32.wrap(res));
    }

    function mul(uint32 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mul(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function checkedMulWithOverflowBit(uint32 a, gtUint32 b) internal returns (gtBool, gtUint32) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedMul(
            combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.LHS_PUBLIC),
            uint256(a),
            gtUint32.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint32.wrap(res));
    }

    function div(uint32 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Div(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function rem(uint32 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Rem(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function and(uint32 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).And(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function or(uint32 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Or(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function xor(uint32 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Xor(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function eq(uint32 a, gtUint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Eq(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function ne(uint32 a, gtUint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ne(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function ge(uint32 a, gtUint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ge(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function gt(uint32 a, gtUint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Gt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function le(uint32 a, gtUint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Le(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function lt(uint32 a, gtUint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Lt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function min(uint32 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Min(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function max(uint32 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Max(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function mux(gtBool bit, uint32 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mux(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.LHS_PUBLIC),
                    gtBool.unwrap(bit),
                    uint256(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    // =========== 64 bit operations ==============

    function add(uint64 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Add(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function checkedAddWithOverflowBit(uint64 a, gtUint64 b) internal returns (gtBool, gtUint64) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedAdd(
            combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.LHS_PUBLIC),
            uint256(a),
            gtUint64.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint64.wrap(res));
    }

    function sub(uint64 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Sub(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function checkedSubWithOverflowBit(uint64 a, gtUint64 b) internal returns (gtBool, gtUint64) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedSub(
            combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.LHS_PUBLIC),
            uint256(a),
            gtUint64.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint64.wrap(res));
    }

    function mul(uint64 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mul(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function checkedMulWithOverflowBit(uint64 a, gtUint64 b) internal returns (gtBool, gtUint64) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedMul(
            combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.LHS_PUBLIC),
            uint256(a),
            gtUint64.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint64.wrap(res));
    }

    function div(uint64 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Div(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function rem(uint64 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Rem(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function and(uint64 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).And(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function or(uint64 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Or(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function xor(uint64 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Xor(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function eq(uint64 a, gtUint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Eq(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function ne(uint64 a, gtUint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ne(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function ge(uint64 a, gtUint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ge(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function gt(uint64 a, gtUint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Gt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function le(uint64 a, gtUint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Le(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function lt(uint64 a, gtUint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Lt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function min(uint64 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Min(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function max(uint64 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Max(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.LHS_PUBLIC),
                    uint256(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function mux(gtBool bit, uint64 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mux(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.LHS_PUBLIC),
                    gtBool.unwrap(bit),
                    uint256(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    // =========== Operations with RHS_PUBLIC parameter ===========
    // =========== 8 bit operations ==============

    function add(gtUint8 a, uint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Add(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.RHS_PUBLIC),
                    gtUint8.unwrap(a),
                    uint256(b)
                )
            );
    }

    function checkedAddWithOverflowBit(gtUint8 a, uint8 b) internal returns (gtBool, gtUint8) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedAdd(
            combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.RHS_PUBLIC),
            gtUint8.unwrap(a),
            uint256(b)
        );

        return (gtBool.wrap(bit), gtUint8.wrap(res));
    }

    function sub(gtUint8 a, uint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Sub(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.RHS_PUBLIC),
                    gtUint8.unwrap(a),
                    uint256(b)
                )
            );
    }

    function checkedSubWithOverflowBit(gtUint8 a, uint8 b) internal returns (gtBool, gtUint8) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedSub(
            combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.RHS_PUBLIC),
            gtUint8.unwrap(a),
            uint256(b)
        );

        return (gtBool.wrap(bit), gtUint8.wrap(res));
    }

    function mul(gtUint8 a, uint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mul(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.RHS_PUBLIC),
                    gtUint8.unwrap(a),
                    uint256(b)
                )
            );
    }

    function checkedMulWithOverflowBit(gtUint8 a, uint8 b) internal returns (gtBool, gtUint8) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedMul(
            combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.RHS_PUBLIC),
            gtUint8.unwrap(a),
            uint256(b)
        );

        return (gtBool.wrap(bit), gtUint8.wrap(res));
    }

    function div(gtUint8 a, uint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Div(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.RHS_PUBLIC),
                    gtUint8.unwrap(a),
                    uint256(b)
                )
            );
    }

    function rem(gtUint8 a, uint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Rem(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.RHS_PUBLIC),
                    gtUint8.unwrap(a),
                    uint256(b)
                )
            );
    }

    function and(gtUint8 a, uint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).And(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.RHS_PUBLIC),
                    gtUint8.unwrap(a),
                    uint256(b)
                )
            );
    }

    function or(gtUint8 a, uint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Or(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.RHS_PUBLIC),
                    gtUint8.unwrap(a),
                    uint256(b)
                )
            );
    }

    function xor(gtUint8 a, uint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Xor(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.RHS_PUBLIC),
                    gtUint8.unwrap(a),
                    uint256(b)
                )
            );
    }

    function shl(gtUint8 a, uint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Shl(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.RHS_PUBLIC),
                    gtUint8.unwrap(a),
                    uint256(b)
                )
            );
    }

    function shr(gtUint8 a, uint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Shr(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.RHS_PUBLIC),
                    gtUint8.unwrap(a),
                    uint256(b)
                )
            );
    }

    function eq(gtUint8 a, uint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Eq(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.RHS_PUBLIC),
                    gtUint8.unwrap(a),
                    uint256(b)
                )
            );
    }

    function ne(gtUint8 a, uint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ne(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.RHS_PUBLIC),
                    gtUint8.unwrap(a),
                    uint256(b)
                )
            );
    }

    function ge(gtUint8 a, uint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ge(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.RHS_PUBLIC),
                    gtUint8.unwrap(a),
                    uint256(b)
                )
            );
    }

    function gt(gtUint8 a, uint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Gt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.RHS_PUBLIC),
                    gtUint8.unwrap(a),
                    uint256(b)
                )
            );
    }

    function le(gtUint8 a, uint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Le(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.RHS_PUBLIC),
                    gtUint8.unwrap(a),
                    uint256(b)
                )
            );
    }

    function lt(gtUint8 a, uint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Lt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.RHS_PUBLIC),
                    gtUint8.unwrap(a),
                    uint256(b)
                )
            );
    }

    function min(gtUint8 a, uint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Min(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.RHS_PUBLIC),
                    gtUint8.unwrap(a),
                    uint256(b)
                )
            );
    }

    function max(gtUint8 a, uint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Max(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.RHS_PUBLIC),
                    gtUint8.unwrap(a),
                    uint256(b)
                )
            );
    }

    function mux(gtBool bit, gtUint8 a, uint8 b) internal returns (gtUint8) {
        return
            gtUint8.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mux(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.RHS_PUBLIC),
                    gtBool.unwrap(bit),
                    gtUint8.unwrap(a),
                    uint256(b)
                )
            );
    }

    // =========== 16 bit operations ==============

    function add(gtUint16 a, uint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Add(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.RHS_PUBLIC),
                    gtUint16.unwrap(a),
                    uint256(b)
                )
            );
    }

    function checkedAddWithOverflowBit(gtUint16 a, uint16 b) internal returns (gtBool, gtUint16) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedAdd(
            combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.RHS_PUBLIC),
            gtUint16.unwrap(a),
            uint256(b)
        );

        return (gtBool.wrap(bit), gtUint16.wrap(res));
    }

    function sub(gtUint16 a, uint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Sub(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.RHS_PUBLIC),
                    gtUint16.unwrap(a),
                    uint256(b)
                )
            );
    }

    function checkedSubWithOverflowBit(gtUint16 a, uint16 b) internal returns (gtBool, gtUint16) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedSub(
            combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.RHS_PUBLIC),
            gtUint16.unwrap(a),
            uint256(b)
        );

        return (gtBool.wrap(bit), gtUint16.wrap(res));
    }

    function mul(gtUint16 a, uint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mul(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.RHS_PUBLIC),
                    gtUint16.unwrap(a),
                    uint256(b)
                )
            );
    }

    function checkedMulWithOverflowBit(gtUint16 a, uint16 b) internal returns (gtBool, gtUint16) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedMul(
            combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.RHS_PUBLIC),
            gtUint16.unwrap(a),
            uint256(b)
        );

        return (gtBool.wrap(bit), gtUint16.wrap(res));
    }

    function div(gtUint16 a, uint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Div(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.RHS_PUBLIC),
                    gtUint16.unwrap(a),
                    uint256(b)
                )
            );
    }

    function rem(gtUint16 a, uint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Rem(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.RHS_PUBLIC),
                    gtUint16.unwrap(a),
                    uint256(b)
                )
            );
    }

    function and(gtUint16 a, uint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).And(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.RHS_PUBLIC),
                    gtUint16.unwrap(a),
                    uint256(b)
                )
            );
    }

    function or(gtUint16 a, uint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Or(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.RHS_PUBLIC),
                    gtUint16.unwrap(a),
                    uint256(b)
                )
            );
    }

    function xor(gtUint16 a, uint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Xor(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.RHS_PUBLIC),
                    gtUint16.unwrap(a),
                    uint256(b)
                )
            );
    }

    function shl(gtUint16 a, uint8 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Shl(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT8_T, ARGS.RHS_PUBLIC),
                    gtUint16.unwrap(a),
                    uint256(b)
                )
            );
    }

    function shr(gtUint16 a, uint8 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Shr(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT8_T, ARGS.RHS_PUBLIC),
                    gtUint16.unwrap(a),
                    uint256(b)
                )
            );
    }

    function eq(gtUint16 a, uint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Eq(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.RHS_PUBLIC),
                    gtUint16.unwrap(a),
                    uint256(b)
                )
            );
    }

    function ne(gtUint16 a, uint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ne(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.RHS_PUBLIC),
                    gtUint16.unwrap(a),
                    uint256(b)
                )
            );
    }

    function ge(gtUint16 a, uint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ge(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.RHS_PUBLIC),
                    gtUint16.unwrap(a),
                    uint256(b)
                )
            );
    }

    function gt(gtUint16 a, uint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Gt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.RHS_PUBLIC),
                    gtUint16.unwrap(a),
                    uint256(b)
                )
            );
    }

    function le(gtUint16 a, uint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Le(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.RHS_PUBLIC),
                    gtUint16.unwrap(a),
                    uint256(b)
                )
            );
    }

    function lt(gtUint16 a, uint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Lt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.RHS_PUBLIC),
                    gtUint16.unwrap(a),
                    uint256(b)
                )
            );
    }

    function min(gtUint16 a, uint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Min(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.RHS_PUBLIC),
                    gtUint16.unwrap(a),
                    uint256(b)
                )
            );
    }

    function max(gtUint16 a, uint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Max(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.RHS_PUBLIC),
                    gtUint16.unwrap(a),
                    uint256(b)
                )
            );
    }

    function mux(gtBool bit, gtUint16 a, uint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mux(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.RHS_PUBLIC),
                    gtBool.unwrap(bit),
                    gtUint16.unwrap(a),
                    uint256(b)
                )
            );
    }

    // =========== 32 bit operations ==============

    function add(gtUint32 a, uint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Add(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.RHS_PUBLIC),
                    gtUint32.unwrap(a),
                    uint256(b)
                )
            );
    }

    function checkedAddWithOverflowBit(gtUint32 a, uint32 b) internal returns (gtBool, gtUint32) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedAdd(
            combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.RHS_PUBLIC),
            gtUint32.unwrap(a),
            uint256(b)
        );

        return (gtBool.wrap(bit), gtUint32.wrap(res));
    }

    function sub(gtUint32 a, uint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Sub(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.RHS_PUBLIC),
                    gtUint32.unwrap(a),
                    uint256(b)
                )
            );
    }

    function checkedSubWithOverflowBit(gtUint32 a, uint32 b) internal returns (gtBool, gtUint32) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedSub(
            combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.RHS_PUBLIC),
            gtUint32.unwrap(a),
            uint256(b)
        );

        return (gtBool.wrap(bit), gtUint32.wrap(res));
    }

    function mul(gtUint32 a, uint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mul(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.RHS_PUBLIC),
                    gtUint32.unwrap(a),
                    uint256(b)
                )
            );
    }

    function checkedMulWithOverflowBit(gtUint32 a, uint32 b) internal returns (gtBool, gtUint32) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedMul(
            combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.RHS_PUBLIC),
            gtUint32.unwrap(a),
            uint256(b)
        );

        return (gtBool.wrap(bit), gtUint32.wrap(res));
    }

    function div(gtUint32 a, uint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Div(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.RHS_PUBLIC),
                    gtUint32.unwrap(a),
                    uint256(b)
                )
            );
    }

    function rem(gtUint32 a, uint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Rem(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.RHS_PUBLIC),
                    gtUint32.unwrap(a),
                    uint256(b)
                )
            );
    }

    function and(gtUint32 a, uint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).And(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.RHS_PUBLIC),
                    gtUint32.unwrap(a),
                    uint256(b)
                )
            );
    }
    function or(gtUint32 a, uint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Or(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.RHS_PUBLIC),
                    gtUint32.unwrap(a),
                    uint256(b)
                )
            );
    }

    function xor(gtUint32 a, uint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Xor(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.RHS_PUBLIC),
                    gtUint32.unwrap(a),
                    uint256(b)
                )
            );
    }

    function shl(gtUint32 a, uint8 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Shl(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT8_T, ARGS.RHS_PUBLIC),
                    gtUint32.unwrap(a),
                    uint256(b)
                )
            );
    }

    function shr(gtUint32 a, uint8 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Shr(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT8_T, ARGS.RHS_PUBLIC),
                    gtUint32.unwrap(a),
                    uint256(b)
                )
            );
    }

    function eq(gtUint32 a, uint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Eq(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.RHS_PUBLIC),
                    gtUint32.unwrap(a),
                    uint256(b)
                )
            );
    }

    function ne(gtUint32 a, uint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ne(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.RHS_PUBLIC),
                    gtUint32.unwrap(a),
                    uint256(b)
                )
            );
    }

    function ge(gtUint32 a, uint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ge(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.RHS_PUBLIC),
                    gtUint32.unwrap(a),
                    uint256(b)
                )
            );
    }

    function gt(gtUint32 a, uint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Gt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.RHS_PUBLIC),
                    gtUint32.unwrap(a),
                    uint256(b)
                )
            );
    }

    function le(gtUint32 a, uint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Le(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.RHS_PUBLIC),
                    gtUint32.unwrap(a),
                    uint256(b)
                )
            );
    }

    function lt(gtUint32 a, uint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Lt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.RHS_PUBLIC),
                    gtUint32.unwrap(a),
                    uint256(b)
                )
            );
    }

    function min(gtUint32 a, uint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Min(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.RHS_PUBLIC),
                    gtUint32.unwrap(a),
                    uint256(b)
                )
            );
    }

    function max(gtUint32 a, uint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Max(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.RHS_PUBLIC),
                    gtUint32.unwrap(a),
                    uint256(b)
                )
            );
    }

    function mux(gtBool bit, gtUint32 a, uint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mux(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.RHS_PUBLIC),
                    gtBool.unwrap(bit),
                    gtUint32.unwrap(a),
                    uint256(b)
                )
            );
    }

    // =========== 64 bit operations ==============

    function add(gtUint64 a, uint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Add(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.RHS_PUBLIC),
                    gtUint64.unwrap(a),
                    uint256(b)
                )
            );
    }

    function checkedAddWithOverflowBit(gtUint64 a, uint64 b) internal returns (gtBool, gtUint64) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedAdd(
            combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.RHS_PUBLIC),
            gtUint64.unwrap(a),
            uint256(b)
        );

        return (gtBool.wrap(bit), gtUint64.wrap(res));
    }

    function sub(gtUint64 a, uint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Sub(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.RHS_PUBLIC),
                    gtUint64.unwrap(a),
                    uint256(b)
                )
            );
    }

    function checkedSubWithOverflowBit(gtUint64 a, uint64 b) internal returns (gtBool, gtUint64) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedSub(
            combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.RHS_PUBLIC),
            gtUint64.unwrap(a),
            uint256(b)
        );

        return (gtBool.wrap(bit), gtUint64.wrap(res));
    }

    function mul(gtUint64 a, uint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mul(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.RHS_PUBLIC),
                    gtUint64.unwrap(a),
                    uint256(b)
                )
            );
    }

    function checkedMulWithOverflowBit(gtUint64 a, uint64 b) internal returns (gtBool, gtUint64) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedMul(
            combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.RHS_PUBLIC),
            gtUint64.unwrap(a),
            uint256(b)
        );

        return (gtBool.wrap(bit), gtUint64.wrap(res));
    }

    function div(gtUint64 a, uint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Div(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.RHS_PUBLIC),
                    gtUint64.unwrap(a),
                    uint256(b)
                )
            );
    }

    function rem(gtUint64 a, uint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Rem(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.RHS_PUBLIC),
                    gtUint64.unwrap(a),
                    uint256(b)
                )
            );
    }

    function and(gtUint64 a, uint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).And(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.RHS_PUBLIC),
                    gtUint64.unwrap(a),
                    uint256(b)
                )
            );
    }

    function or(gtUint64 a, uint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Or(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.RHS_PUBLIC),
                    gtUint64.unwrap(a),
                    uint256(b)
                )
            );
    }

    function xor(gtUint64 a, uint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Xor(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.RHS_PUBLIC),
                    gtUint64.unwrap(a),
                    uint256(b)
                )
            );
    }

    function shl(gtUint64 a, uint8 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Shl(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT8_T, ARGS.RHS_PUBLIC),
                    gtUint64.unwrap(a),
                    uint256(b)
                )
            );
    }

    function shr(gtUint64 a, uint8 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Shr(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT8_T, ARGS.RHS_PUBLIC),
                    gtUint64.unwrap(a),
                    uint256(b)
                )
            );
    }

    function eq(gtUint64 a, uint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Eq(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.RHS_PUBLIC),
                    gtUint64.unwrap(a),
                    uint256(b)
                )
            );
    }

    function ne(gtUint64 a, uint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ne(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.RHS_PUBLIC),
                    gtUint64.unwrap(a),
                    uint256(b)
                )
            );
    }

    function ge(gtUint64 a, uint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ge(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.RHS_PUBLIC),
                    gtUint64.unwrap(a),
                    uint256(b)
                )
            );
    }

    function gt(gtUint64 a, uint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Gt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.RHS_PUBLIC),
                    gtUint64.unwrap(a),
                    uint256(b)
                )
            );
    }

    function le(gtUint64 a, uint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Le(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.RHS_PUBLIC),
                    gtUint64.unwrap(a),
                    uint256(b)
                )
            );
    }

    function lt(gtUint64 a, uint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Lt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.RHS_PUBLIC),
                    gtUint64.unwrap(a),
                    uint256(b)
                )
            );
    }

    function min(gtUint64 a, uint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Min(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.RHS_PUBLIC),
                    gtUint64.unwrap(a),
                    uint256(b)
                )
            );
    }

    function max(gtUint64 a, uint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Max(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.RHS_PUBLIC),
                    gtUint64.unwrap(a),
                    uint256(b)
                )
            );
    }

    function mux(gtBool bit, gtUint64 a, uint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mux(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.RHS_PUBLIC),
                    gtBool.unwrap(bit),
                    gtUint64.unwrap(a),
                    uint256(b)
                )
            );
    }

    // In the context of a transfer, scalar balances are irrelevant;
    // The only possibility for a scalar value is within the "amount" parameter.
    // Therefore, in this scenario, LHS_PUBLIC signifies a scalar amount, not balance1.

    function transfer(gtUint8 a, gtUint8 b, uint8 amount) internal returns (gtUint8, gtUint8, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.LHS_PUBLIC),
                gtUint8.unwrap(a),
                gtUint8.unwrap(b),
                uint256(amount)
            );
        return (gtUint8.wrap(new_a), gtUint8.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint16 a, gtUint16 b, uint16 amount) internal returns (gtUint16, gtUint16, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.LHS_PUBLIC),
                gtUint16.unwrap(a),
                gtUint16.unwrap(b),
                uint256(amount)
            );
        return (gtUint16.wrap(new_a), gtUint16.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint8 a, gtUint16 b, uint16 amount) internal returns (gtUint16, gtUint16, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.LHS_PUBLIC),
                gtUint8.unwrap(a),
                gtUint16.unwrap(b),
                uint256(amount)
            );
        return (gtUint16.wrap(new_a), gtUint16.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint16 a, gtUint8 b, uint16 amount) internal returns (gtUint16, gtUint16, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT16_T, ARGS.LHS_PUBLIC),
                gtUint16.unwrap(a),
                gtUint8.unwrap(b),
                uint256(amount)
            );
        return (gtUint16.wrap(new_a), gtUint16.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint32 a, gtUint32 b, uint32 amount) internal returns (gtUint32, gtUint32, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.LHS_PUBLIC),
                gtUint32.unwrap(a),
                gtUint32.unwrap(b),
                uint256(amount)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint8 a, gtUint32 b, uint32 amount) internal returns (gtUint32, gtUint32, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.LHS_PUBLIC),
                gtUint8.unwrap(a),
                gtUint32.unwrap(b),
                uint256(amount)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint32 a, gtUint8 b, uint32 amount) internal returns (gtUint32, gtUint32, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT32_T, ARGS.LHS_PUBLIC),
                gtUint32.unwrap(a),
                gtUint8.unwrap(b),
                uint256(amount)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint16 a, gtUint32 b, uint32 amount) internal returns (gtUint32, gtUint32, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.LHS_PUBLIC),
                gtUint16.unwrap(a),
                gtUint32.unwrap(b),
                uint256(amount)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint32 a, gtUint16 b, uint32 amount) internal returns (gtUint32, gtUint32, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT32_T, ARGS.LHS_PUBLIC),
                gtUint32.unwrap(a),
                gtUint16.unwrap(b),
                uint256(amount)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint64 a, gtUint64 b, uint64 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.LHS_PUBLIC),
                gtUint64.unwrap(a),
                gtUint64.unwrap(b),
                uint256(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint8 a, gtUint64 b, uint64 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.LHS_PUBLIC),
                gtUint8.unwrap(a),
                gtUint64.unwrap(b),
                uint256(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint64 a, gtUint8 b, uint64 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT64_T, ARGS.LHS_PUBLIC),
                gtUint64.unwrap(a),
                gtUint8.unwrap(b),
                uint256(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint16 a, gtUint64 b, uint64 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.LHS_PUBLIC),
                gtUint16.unwrap(a),
                gtUint64.unwrap(b),
                uint256(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint64 a, gtUint16 b, uint64 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT64_T, ARGS.LHS_PUBLIC),
                gtUint64.unwrap(a),
                gtUint16.unwrap(b),
                uint256(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint32 a, gtUint64 b, uint64 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.LHS_PUBLIC),
                gtUint32.unwrap(a),
                gtUint64.unwrap(b),
                uint256(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint64 a, gtUint32 b, uint64 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT64_T, ARGS.LHS_PUBLIC),
                gtUint64.unwrap(a),
                gtUint32.unwrap(b),
                uint256(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint8 b,
        uint8 amount,
        gtUint8 allowance
    ) internal returns (gtUint8, gtUint8, gtBool, gtUint8) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint8.unwrap(a),
                gtUint8.unwrap(b),
                uint256(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint8.wrap(new_a), gtUint8.wrap(new_b), gtBool.wrap(res), gtUint8.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint16 b,
        uint16 amount,
        gtUint16 allowance
    ) internal returns (gtUint16, gtUint16, gtBool, gtUint16) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint16.unwrap(a),
                gtUint16.unwrap(b),
                uint256(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint16.wrap(new_a), gtUint16.wrap(new_b), gtBool.wrap(res), gtUint16.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint16 b,
        uint16 amount,
        gtUint16 allowance
    ) internal returns (gtUint16, gtUint16, gtBool, gtUint16) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint8.unwrap(a),
                gtUint16.unwrap(b),
                uint256(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint16.wrap(new_a), gtUint16.wrap(new_b), gtBool.wrap(res), gtUint16.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint8 b,
        uint16 amount,
        gtUint16 allowance
    ) internal returns (gtUint16, gtUint16, gtBool, gtUint16) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint16.unwrap(a),
                gtUint8.unwrap(b),
                uint256(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint16.wrap(new_a), gtUint16.wrap(new_b), gtBool.wrap(res), gtUint16.wrap(new_allowance));
    }

    // Allowance with 8 bits
    function transferWithAllowance(
        gtUint16 a,
        gtUint16 b,
        uint16 amount,
        gtUint8 allowance
    ) internal returns (gtUint16, gtUint16, gtBool, gtUint16) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint16.unwrap(a),
                gtUint16.unwrap(b),
                uint256(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint16.wrap(new_a), gtUint16.wrap(new_b), gtBool.wrap(res), gtUint16.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint16 b,
        uint16 amount,
        gtUint8 allowance
    ) internal returns (gtUint16, gtUint16, gtBool, gtUint16) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint8.unwrap(a),
                gtUint16.unwrap(b),
                uint256(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint16.wrap(new_a), gtUint16.wrap(new_b), gtBool.wrap(res), gtUint16.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint8 b,
        uint16 amount,
        gtUint8 allowance
    ) internal returns (gtUint16, gtUint16, gtBool, gtUint16) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint16.unwrap(a),
                gtUint8.unwrap(b),
                uint256(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint16.wrap(new_a), gtUint16.wrap(new_b), gtBool.wrap(res), gtUint16.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint32 b,
        uint32 amount,
        gtUint32 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint32.unwrap(a),
                gtUint32.unwrap(b),
                uint256(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint32 b,
        uint32 amount,
        gtUint32 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint8.unwrap(a),
                gtUint32.unwrap(b),
                uint256(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint8 b,
        uint32 amount,
        gtUint32 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint32.unwrap(a),
                gtUint8.unwrap(b),
                uint256(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint32 b,
        uint32 amount,
        gtUint32 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint16.unwrap(a),
                gtUint32.unwrap(b),
                uint256(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint16 b,
        uint32 amount,
        gtUint32 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint32.unwrap(a),
                gtUint16.unwrap(b),
                uint256(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    // Allowance with 8 bits
    function transferWithAllowance(
        gtUint32 a,
        gtUint32 b,
        uint32 amount,
        gtUint8 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint32.unwrap(a),
                gtUint32.unwrap(b),
                uint256(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint32 b,
        uint32 amount,
        gtUint8 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint8.unwrap(a),
                gtUint32.unwrap(b),
                uint256(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint8 b,
        uint32 amount,
        gtUint8 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint32.unwrap(a),
                gtUint8.unwrap(b),
                uint256(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint32 b,
        uint32 amount,
        gtUint8 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint16.unwrap(a),
                gtUint32.unwrap(b),
                uint256(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint16 b,
        uint32 amount,
        gtUint8 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint32.unwrap(a),
                gtUint16.unwrap(b),
                uint256(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    // Allowance with 16 bits
    function transferWithAllowance(
        gtUint32 a,
        gtUint32 b,
        uint32 amount,
        gtUint16 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint32.unwrap(a),
                gtUint32.unwrap(b),
                uint256(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint32 b,
        uint32 amount,
        gtUint16 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint8.unwrap(a),
                gtUint32.unwrap(b),
                uint256(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint8 b,
        uint32 amount,
        gtUint16 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint32.unwrap(a),
                gtUint8.unwrap(b),
                uint256(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint32 b,
        uint32 amount,
        gtUint16 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint16.unwrap(a),
                gtUint32.unwrap(b),
                uint256(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint16 b,
        uint32 amount,
        gtUint16 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint32.unwrap(a),
                gtUint16.unwrap(b),
                uint256(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint64 b,
        uint64 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint64.unwrap(a),
                gtUint64.unwrap(b),
                uint256(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint64 b,
        uint64 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint8.unwrap(a),
                gtUint64.unwrap(b),
                uint256(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint8 b,
        uint64 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint64.unwrap(a),
                gtUint8.unwrap(b),
                uint256(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint64 b,
        uint64 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint16.unwrap(a),
                gtUint64.unwrap(b),
                uint256(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint16 b,
        uint64 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint64.unwrap(a),
                gtUint16.unwrap(b),
                uint256(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint64 b,
        uint64 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint32.unwrap(a),
                gtUint64.unwrap(b),
                uint256(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint32 b,
        uint64 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint64.unwrap(a),
                gtUint32.unwrap(b),
                uint256(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    // Allowance with 8 bits
    function transferWithAllowance(
        gtUint64 a,
        gtUint64 b,
        uint64 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint64.unwrap(a),
                gtUint64.unwrap(b),
                uint256(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint64 b,
        uint64 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint8.unwrap(a),
                gtUint64.unwrap(b),
                uint256(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint8 b,
        uint64 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint64.unwrap(a),
                gtUint8.unwrap(b),
                uint256(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint64 b,
        uint64 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint16.unwrap(a),
                gtUint64.unwrap(b),
                uint256(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint16 b,
        uint64 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint64.unwrap(a),
                gtUint16.unwrap(b),
                uint256(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint64 b,
        uint64 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint32.unwrap(a),
                gtUint64.unwrap(b),
                uint256(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint32 b,
        uint64 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint64.unwrap(a),
                gtUint32.unwrap(b),
                uint256(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    // Allowance with 16 bits
    function transferWithAllowance(
        gtUint64 a,
        gtUint64 b,
        uint64 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint64.unwrap(a),
                gtUint64.unwrap(b),
                uint256(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint64 b,
        uint64 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint8.unwrap(a),
                gtUint64.unwrap(b),
                uint256(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint8 b,
        uint64 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint64.unwrap(a),
                gtUint8.unwrap(b),
                uint256(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint64 b,
        uint64 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint16.unwrap(a),
                gtUint64.unwrap(b),
                uint256(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint16 b,
        uint64 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint64.unwrap(a),
                gtUint16.unwrap(b),
                uint256(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint64 b,
        uint64 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint32.unwrap(a),
                gtUint64.unwrap(b),
                uint256(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint32 b,
        uint64 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint64.unwrap(a),
                gtUint32.unwrap(b),
                uint256(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    // Allowance with 32 bits
    function transferWithAllowance(
        gtUint64 a,
        gtUint64 b,
        uint64 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint64.unwrap(a),
                gtUint64.unwrap(b),
                uint256(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint64 b,
        uint64 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint8.unwrap(a),
                gtUint64.unwrap(b),
                uint256(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint8 b,
        uint64 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint64.unwrap(a),
                gtUint8.unwrap(b),
                uint256(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint64 b,
        uint64 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint16.unwrap(a),
                gtUint64.unwrap(b),
                uint256(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint16 b,
        uint64 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint64.unwrap(a),
                gtUint16.unwrap(b),
                uint256(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint64 b,
        uint64 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint32.unwrap(a),
                gtUint64.unwrap(b),
                uint256(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint32 b,
        uint64 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.LHS_PUBLIC
                ),
                gtUint64.unwrap(a),
                gtUint32.unwrap(b),
                uint256(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    // ================= Cast operation =================
    // =========== 8 - 16 bit operations ==============

    function add(gtUint8 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Add(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function add(gtUint16 a, gtUint8 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Add(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function checkedAddWithOverflowBit(gtUint8 a, gtUint16 b) internal returns (gtBool, gtUint16) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedAdd(
            combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
            gtUint8.unwrap(a),
            gtUint16.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint16.wrap(res));
    }

    function checkedAddWithOverflowBit(gtUint16 a, gtUint8 b) internal returns (gtBool, gtUint16) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedAdd(
            combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
            gtUint16.unwrap(a),
            gtUint8.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint16.wrap(res));
    }

    function sub(gtUint8 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Sub(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function sub(gtUint16 a, gtUint8 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Sub(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function checkedSubWithOverflowBit(gtUint8 a, gtUint16 b) internal returns (gtBool, gtUint16) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedSub(
            combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
            gtUint8.unwrap(a),
            gtUint16.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint16.wrap(res));
    }

    function checkedSubWithOverflowBit(gtUint16 a, gtUint8 b) internal returns (gtBool, gtUint16) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedSub(
            combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
            gtUint16.unwrap(a),
            gtUint8.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint16.wrap(res));
    }

    function mul(gtUint8 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mul(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function mul(gtUint16 a, gtUint8 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mul(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function checkedMulWithOverflowBit(gtUint8 a, gtUint16 b) internal returns (gtBool, gtUint16) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedMul(
            combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
            gtUint8.unwrap(a),
            gtUint16.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint16.wrap(res));
    }

    function checkedMulWithOverflowBit(gtUint16 a, gtUint8 b) internal returns (gtBool, gtUint16) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedMul(
            combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
            gtUint16.unwrap(a),
            gtUint8.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint16.wrap(res));
    }

    function div(gtUint8 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Div(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function div(gtUint16 a, gtUint8 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Div(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function rem(gtUint8 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Rem(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function rem(gtUint16 a, gtUint8 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Rem(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function and(gtUint8 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).And(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function and(gtUint16 a, gtUint8 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).And(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function or(gtUint8 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Or(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function or(gtUint16 a, gtUint8 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Or(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function xor(gtUint8 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Xor(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function xor(gtUint16 a, gtUint8 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Xor(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function eq(gtUint8 a, gtUint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Eq(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function eq(gtUint16 a, gtUint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Eq(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function ne(gtUint8 a, gtUint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ne(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function ne(gtUint16 a, gtUint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ne(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function ge(gtUint8 a, gtUint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ge(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function ge(gtUint16 a, gtUint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ge(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function gt(gtUint8 a, gtUint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Gt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function gt(gtUint16 a, gtUint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Gt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function le(gtUint8 a, gtUint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Le(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function le(gtUint16 a, gtUint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Le(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function lt(gtUint8 a, gtUint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Lt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function lt(gtUint16 a, gtUint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Lt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function min(gtUint8 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Min(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function min(gtUint16 a, gtUint8 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Min(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function max(gtUint8 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Max(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function max(gtUint16 a, gtUint8 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Max(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function mux(gtBool bit, gtUint8 a, gtUint16 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mux(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtBool.unwrap(bit),
                    gtUint8.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function mux(gtBool bit, gtUint16 a, gtUint8 b) internal returns (gtUint16) {
        return
            gtUint16.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mux(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtBool.unwrap(bit),
                    gtUint16.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function transfer(gtUint8 a, gtUint16 b, gtUint16 amount) internal returns (gtUint16, gtUint16, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                gtUint8.unwrap(a),
                gtUint16.unwrap(b),
                gtUint16.unwrap(amount)
            );
        return (gtUint16.wrap(new_a), gtUint16.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint16 a, gtUint8 b, gtUint16 amount) internal returns (gtUint16, gtUint16, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                gtUint16.unwrap(a),
                gtUint8.unwrap(b),
                gtUint16.unwrap(amount)
            );
        return (gtUint16.wrap(new_a), gtUint16.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint8 a, gtUint16 b, gtUint8 amount) internal returns (gtUint16, gtUint16, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                gtUint8.unwrap(a),
                gtUint16.unwrap(b),
                gtUint8.unwrap(amount)
            );
        return (gtUint16.wrap(new_a), gtUint16.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint16 a, gtUint8 b, gtUint8 amount) internal returns (gtUint16, gtUint16, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                gtUint16.unwrap(a),
                gtUint8.unwrap(b),
                gtUint8.unwrap(amount)
            );
        return (gtUint16.wrap(new_a), gtUint16.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint16 a, gtUint16 b, gtUint8 amount) internal returns (gtUint16, gtUint16, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                gtUint16.unwrap(a),
                gtUint16.unwrap(b),
                gtUint8.unwrap(amount)
            );
        return (gtUint16.wrap(new_a), gtUint16.wrap(new_b), gtBool.wrap(res));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint8 b,
        gtUint8 amount,
        gtUint8 allowance
    ) internal returns (gtUint16, gtUint16, gtBool, gtUint16) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint8.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint16.wrap(new_a), gtUint16.wrap(new_b), gtBool.wrap(res), gtUint16.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint16 b,
        gtUint8 amount,
        gtUint8 allowance
    ) internal returns (gtUint16, gtUint16, gtBool, gtUint16) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint8.unwrap(a),
                gtUint16.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint16.wrap(new_a), gtUint16.wrap(new_b), gtBool.wrap(res), gtUint16.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint8 b,
        gtUint16 amount,
        gtUint8 allowance
    ) internal returns (gtUint16, gtUint16, gtBool, gtUint16) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint8.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint16.wrap(new_a), gtUint16.wrap(new_b), gtBool.wrap(res), gtUint16.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint16 b,
        gtUint16 amount,
        gtUint8 allowance
    ) internal returns (gtUint16, gtUint16, gtBool, gtUint16) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint8.unwrap(a),
                gtUint16.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint16.wrap(new_a), gtUint16.wrap(new_b), gtBool.wrap(res), gtUint16.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint16 b,
        gtUint8 amount,
        gtUint8 allowance
    ) internal returns (gtUint16, gtUint16, gtBool, gtUint16) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint16.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint16.wrap(new_a), gtUint16.wrap(new_b), gtBool.wrap(res), gtUint16.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint16 b,
        gtUint16 amount,
        gtUint8 allowance
    ) internal returns (gtUint16, gtUint16, gtBool, gtUint16) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint16.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint16.wrap(new_a), gtUint16.wrap(new_b), gtBool.wrap(res), gtUint16.wrap(new_allowance));
    }

    // Allowance with 16 bit

    function transferWithAllowance(
        gtUint16 a,
        gtUint8 b,
        gtUint8 amount,
        gtUint16 allowance
    ) internal returns (gtUint16, gtUint16, gtBool, gtUint16) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint8.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint16.wrap(new_a), gtUint16.wrap(new_b), gtBool.wrap(res), gtUint16.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint16 b,
        gtUint8 amount,
        gtUint16 allowance
    ) internal returns (gtUint16, gtUint16, gtBool, gtUint16) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint8.unwrap(a),
                gtUint16.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint16.wrap(new_a), gtUint16.wrap(new_b), gtBool.wrap(res), gtUint16.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint8 b,
        gtUint16 amount,
        gtUint16 allowance
    ) internal returns (gtUint16, gtUint16, gtBool, gtUint16) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint8.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint16.wrap(new_a), gtUint16.wrap(new_b), gtBool.wrap(res), gtUint16.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint16 b,
        gtUint16 amount,
        gtUint16 allowance
    ) internal returns (gtUint16, gtUint16, gtBool, gtUint16) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint8.unwrap(a),
                gtUint16.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint16.wrap(new_a), gtUint16.wrap(new_b), gtBool.wrap(res), gtUint16.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint16 b,
        gtUint8 amount,
        gtUint16 allowance
    ) internal returns (gtUint16, gtUint16, gtBool, gtUint16) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint16.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint16.wrap(new_a), gtUint16.wrap(new_b), gtBool.wrap(res), gtUint16.wrap(new_allowance));
    }

    // =========== 8- 32 bit operations ==============

    function add(gtUint8 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Add(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function add(gtUint32 a, gtUint8 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Add(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function checkedAddWithOverflowBit(gtUint8 a, gtUint32 b) internal returns (gtBool, gtUint32) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedAdd(
            combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
            gtUint8.unwrap(a),
            gtUint32.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint32.wrap(res));
    }

    function checkedAddWithOverflowBit(gtUint32 a, gtUint8 b) internal returns (gtBool, gtUint32) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedAdd(
            combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
            gtUint32.unwrap(a),
            gtUint8.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint32.wrap(res));
    }

    function sub(gtUint8 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Sub(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function sub(gtUint32 a, gtUint8 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Sub(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function checkedSubWithOverflowBit(gtUint8 a, gtUint32 b) internal returns (gtBool, gtUint32) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedSub(
            combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
            gtUint8.unwrap(a),
            gtUint32.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint32.wrap(res));
    }

    function checkedSubWithOverflowBit(gtUint32 a, gtUint8 b) internal returns (gtBool, gtUint32) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedSub(
            combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
            gtUint32.unwrap(a),
            gtUint8.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint32.wrap(res));
    }

    function mul(gtUint8 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mul(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function mul(gtUint32 a, gtUint8 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mul(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function checkedMulWithOverflowBit(gtUint8 a, gtUint32 b) internal returns (gtBool, gtUint32) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedMul(
            combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
            gtUint8.unwrap(a),
            gtUint32.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint32.wrap(res));
    }

    function checkedMulWithOverflowBit(gtUint32 a, gtUint8 b) internal returns (gtBool, gtUint32) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedMul(
            combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
            gtUint32.unwrap(a),
            gtUint8.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint32.wrap(res));
    }

    function div(gtUint8 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Div(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function div(gtUint32 a, gtUint8 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Div(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function rem(gtUint8 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Rem(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function rem(gtUint32 a, gtUint8 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Rem(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function and(gtUint8 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).And(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function and(gtUint32 a, gtUint8 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).And(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function or(gtUint8 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Or(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function or(gtUint32 a, gtUint8 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Or(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function xor(gtUint8 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Xor(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function xor(gtUint32 a, gtUint8 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Xor(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function eq(gtUint8 a, gtUint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Eq(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function eq(gtUint32 a, gtUint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Eq(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function ne(gtUint8 a, gtUint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ne(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function ne(gtUint32 a, gtUint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ne(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function ge(gtUint8 a, gtUint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ge(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function ge(gtUint32 a, gtUint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ge(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function gt(gtUint8 a, gtUint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Gt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function gt(gtUint32 a, gtUint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Gt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function le(gtUint8 a, gtUint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Le(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function le(gtUint32 a, gtUint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Le(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function lt(gtUint8 a, gtUint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Lt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function lt(gtUint32 a, gtUint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Lt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function min(gtUint8 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Min(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function min(gtUint32 a, gtUint8 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Min(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function max(gtUint8 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Max(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function max(gtUint32 a, gtUint8 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Max(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function mux(gtBool bit, gtUint8 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mux(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtBool.unwrap(bit),
                    gtUint8.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function mux(gtBool bit, gtUint32 a, gtUint8 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mux(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtBool.unwrap(bit),
                    gtUint32.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function transfer(gtUint8 a, gtUint32 b, gtUint32 amount) internal returns (gtUint32, gtUint32, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                gtUint8.unwrap(a),
                gtUint32.unwrap(b),
                gtUint32.unwrap(amount)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint32 a, gtUint8 b, gtUint32 amount) internal returns (gtUint32, gtUint32, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                gtUint32.unwrap(a),
                gtUint8.unwrap(b),
                gtUint32.unwrap(amount)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint8 a, gtUint32 b, gtUint8 amount) internal returns (gtUint32, gtUint32, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                gtUint8.unwrap(a),
                gtUint32.unwrap(b),
                gtUint8.unwrap(amount)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint32 a, gtUint8 b, gtUint8 amount) internal returns (gtUint32, gtUint32, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                gtUint32.unwrap(a),
                gtUint8.unwrap(b),
                gtUint8.unwrap(amount)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint8 a, gtUint32 b, gtUint16 amount) internal returns (gtUint32, gtUint32, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                gtUint8.unwrap(a),
                gtUint32.unwrap(b),
                gtUint16.unwrap(amount)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint32 a, gtUint8 b, gtUint16 amount) internal returns (gtUint32, gtUint32, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                gtUint32.unwrap(a),
                gtUint8.unwrap(b),
                gtUint16.unwrap(amount)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint32 a, gtUint32 b, gtUint8 amount) internal returns (gtUint32, gtUint32, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                gtUint32.unwrap(a),
                gtUint32.unwrap(b),
                gtUint8.unwrap(amount)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint8 b,
        gtUint8 amount,
        gtUint8 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint8.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint32 b,
        gtUint8 amount,
        gtUint8 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint8.unwrap(a),
                gtUint32.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint8 b,
        gtUint32 amount,
        gtUint8 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint8.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint32 b,
        gtUint32 amount,
        gtUint8 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint8.unwrap(a),
                gtUint32.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint32 b,
        gtUint32 amount,
        gtUint8 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint32.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint8 b,
        gtUint16 amount,
        gtUint8 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint8.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint32 b,
        gtUint16 amount,
        gtUint8 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint8.unwrap(a),
                gtUint32.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint32 b,
        gtUint8 amount,
        gtUint8 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint32.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    // Allowance with 16 bit
    function transferWithAllowance(
        gtUint32 a,
        gtUint8 b,
        gtUint8 amount,
        gtUint16 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint8.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint32 b,
        gtUint8 amount,
        gtUint16 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint8.unwrap(a),
                gtUint32.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint8 b,
        gtUint32 amount,
        gtUint16 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint8.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint32 b,
        gtUint32 amount,
        gtUint16 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint8.unwrap(a),
                gtUint32.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint8 b,
        gtUint16 amount,
        gtUint16 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint8.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint32 b,
        gtUint16 amount,
        gtUint16 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint8.unwrap(a),
                gtUint32.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint32 b,
        gtUint8 amount,
        gtUint16 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint32.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    // Allowance with 32 bit
    function transferWithAllowance(
        gtUint32 a,
        gtUint8 b,
        gtUint8 amount,
        gtUint32 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint8.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint32 b,
        gtUint8 amount,
        gtUint32 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint8.unwrap(a),
                gtUint32.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint8 b,
        gtUint32 amount,
        gtUint32 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint8.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint32 b,
        gtUint32 amount,
        gtUint32 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint8.unwrap(a),
                gtUint32.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint8 b,
        gtUint16 amount,
        gtUint32 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint8.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint32 b,
        gtUint16 amount,
        gtUint32 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint8.unwrap(a),
                gtUint32.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint32 b,
        gtUint8 amount,
        gtUint32 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint32.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    // =========== 16 - 32 bit operations ==============

    function add(gtUint16 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Add(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function add(gtUint32 a, gtUint16 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Add(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function checkedAddWithOverflowBit(gtUint16 a, gtUint32 b) internal returns (gtBool, gtUint32) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedAdd(
            combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
            gtUint16.unwrap(a),
            gtUint32.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint32.wrap(res));
    }

    function checkedAddWithOverflowBit(gtUint32 a, gtUint16 b) internal returns (gtBool, gtUint32) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedAdd(
            combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
            gtUint32.unwrap(a),
            gtUint16.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint32.wrap(res));
    }

    function sub(gtUint16 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Sub(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function sub(gtUint32 a, gtUint16 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Sub(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function checkedSubWithOverflowBit(gtUint16 a, gtUint32 b) internal returns (gtBool, gtUint32) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedSub(
            combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
            gtUint16.unwrap(a),
            gtUint32.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint32.wrap(res));
    }

    function checkedSubWithOverflowBit(gtUint32 a, gtUint16 b) internal returns (gtBool, gtUint32) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedSub(
            combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
            gtUint32.unwrap(a),
            gtUint16.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint32.wrap(res));
    }

    function mul(gtUint16 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mul(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function mul(gtUint32 a, gtUint16 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mul(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function checkedMulWithOverflowBit(gtUint16 a, gtUint32 b) internal returns (gtBool, gtUint32) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedMul(
            combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
            gtUint16.unwrap(a),
            gtUint32.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint32.wrap(res));
    }

    function checkedMulWithOverflowBit(gtUint32 a, gtUint16 b) internal returns (gtBool, gtUint32) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedMul(
            combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
            gtUint32.unwrap(a),
            gtUint16.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint32.wrap(res));
    }

    function div(gtUint16 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Div(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function div(gtUint32 a, gtUint16 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Div(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function rem(gtUint16 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Rem(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function rem(gtUint32 a, gtUint16 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Rem(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function and(gtUint16 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).And(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function and(gtUint32 a, gtUint16 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).And(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function or(gtUint16 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Or(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function or(gtUint32 a, gtUint16 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Or(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function xor(gtUint16 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Xor(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function xor(gtUint32 a, gtUint16 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Xor(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function eq(gtUint16 a, gtUint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Eq(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function eq(gtUint32 a, gtUint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Eq(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function ne(gtUint16 a, gtUint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ne(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function ne(gtUint32 a, gtUint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ne(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function ge(gtUint16 a, gtUint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ge(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function ge(gtUint32 a, gtUint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ge(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function gt(gtUint16 a, gtUint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Gt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function gt(gtUint32 a, gtUint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Gt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function le(gtUint16 a, gtUint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Le(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function le(gtUint32 a, gtUint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Le(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function lt(gtUint16 a, gtUint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Lt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function lt(gtUint32 a, gtUint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Lt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function min(gtUint16 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Min(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function min(gtUint32 a, gtUint16 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Min(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function max(gtUint16 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Max(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function max(gtUint32 a, gtUint16 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Max(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function mux(gtBool bit, gtUint16 a, gtUint32 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mux(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtBool.unwrap(bit),
                    gtUint16.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function mux(gtBool bit, gtUint32 a, gtUint16 b) internal returns (gtUint32) {
        return
            gtUint32.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mux(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtBool.unwrap(bit),
                    gtUint32.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function transfer(gtUint16 a, gtUint32 b, gtUint32 amount) internal returns (gtUint32, gtUint32, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                gtUint16.unwrap(a),
                gtUint32.unwrap(b),
                gtUint32.unwrap(amount)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint32 a, gtUint16 b, gtUint32 amount) internal returns (gtUint32, gtUint32, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                gtUint32.unwrap(a),
                gtUint16.unwrap(b),
                gtUint32.unwrap(amount)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint16 a, gtUint32 b, gtUint8 amount) internal returns (gtUint32, gtUint32, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                gtUint16.unwrap(a),
                gtUint32.unwrap(b),
                gtUint8.unwrap(amount)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint32 a, gtUint16 b, gtUint8 amount) internal returns (gtUint32, gtUint32, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                gtUint32.unwrap(a),
                gtUint16.unwrap(b),
                gtUint8.unwrap(amount)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint16 a, gtUint32 b, gtUint16 amount) internal returns (gtUint32, gtUint32, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                gtUint16.unwrap(a),
                gtUint32.unwrap(b),
                gtUint16.unwrap(amount)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint32 a, gtUint16 b, gtUint16 amount) internal returns (gtUint32, gtUint32, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                gtUint32.unwrap(a),
                gtUint16.unwrap(b),
                gtUint16.unwrap(amount)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint32 a, gtUint32 b, gtUint16 amount) internal returns (gtUint32, gtUint32, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                gtUint32.unwrap(a),
                gtUint32.unwrap(b),
                gtUint16.unwrap(amount)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint32 b,
        gtUint8 amount,
        gtUint8 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint32.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint16 b,
        gtUint8 amount,
        gtUint8 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint16.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint32 b,
        gtUint16 amount,
        gtUint8 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint32.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint16 b,
        gtUint16 amount,
        gtUint8 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint16.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint32 b,
        gtUint32 amount,
        gtUint8 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint32.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint16 b,
        gtUint32 amount,
        gtUint8 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint16.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint32 b,
        gtUint16 amount,
        gtUint8 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint32.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    // Allowance with 16 bit
    function transferWithAllowance(
        gtUint16 a,
        gtUint32 b,
        gtUint8 amount,
        gtUint16 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint32.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint16 b,
        gtUint8 amount,
        gtUint16 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint16.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint32 b,
        gtUint16 amount,
        gtUint16 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint32.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint16 b,
        gtUint16 amount,
        gtUint16 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint16.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint32 b,
        gtUint32 amount,
        gtUint16 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint32.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint16 b,
        gtUint32 amount,
        gtUint16 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint16.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint32 b,
        gtUint16 amount,
        gtUint16 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint32.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint32 b,
        gtUint32 amount,
        gtUint16 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint32.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    // Allowance with 32 bit
    function transferWithAllowance(
        gtUint16 a,
        gtUint32 b,
        gtUint8 amount,
        gtUint32 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint32.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint16 b,
        gtUint8 amount,
        gtUint32 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint16.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint32 b,
        gtUint16 amount,
        gtUint32 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint32.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint16 b,
        gtUint16 amount,
        gtUint32 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint16.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint32 b,
        gtUint32 amount,
        gtUint32 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint32.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint16 b,
        gtUint32 amount,
        gtUint32 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint16.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint32 b,
        gtUint16 amount,
        gtUint32 allowance
    ) internal returns (gtUint32, gtUint32, gtBool, gtUint32) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint32.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint32.wrap(new_a), gtUint32.wrap(new_b), gtBool.wrap(res), gtUint32.wrap(new_allowance));
    }

    // =========== 8 - 64 bit operations ==============

    function add(gtUint8 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Add(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function add(gtUint64 a, gtUint8 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Add(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function checkedAddWithOverflowBit(gtUint8 a, gtUint64 b) internal returns (gtBool, gtUint64) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedAdd(
            combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
            gtUint8.unwrap(a),
            gtUint64.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint64.wrap(res));
    }

    function checkedAddWithOverflowBit(gtUint64 a, gtUint8 b) internal returns (gtBool, gtUint64) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedAdd(
            combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
            gtUint64.unwrap(a),
            gtUint8.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint64.wrap(res));
    }

    function sub(gtUint8 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Sub(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function sub(gtUint64 a, gtUint8 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Sub(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function checkedSubWithOverflowBit(gtUint8 a, gtUint64 b) internal returns (gtBool, gtUint64) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedSub(
            combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
            gtUint8.unwrap(a),
            gtUint64.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint64.wrap(res));
    }

    function checkedSubWithOverflowBit(gtUint64 a, gtUint8 b) internal returns (gtBool, gtUint64) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedSub(
            combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
            gtUint64.unwrap(a),
            gtUint8.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint64.wrap(res));
    }

    function mul(gtUint8 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mul(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function mul(gtUint64 a, gtUint8 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mul(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function checkedMulWithOverflowBit(gtUint8 a, gtUint64 b) internal returns (gtBool, gtUint64) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedMul(
            combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
            gtUint8.unwrap(a),
            gtUint64.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint64.wrap(res));
    }

    function checkedMulWithOverflowBit(gtUint64 a, gtUint8 b) internal returns (gtBool, gtUint64) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedMul(
            combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
            gtUint64.unwrap(a),
            gtUint8.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint64.wrap(res));
    }

    function div(gtUint8 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Div(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function div(gtUint64 a, gtUint8 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Div(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function rem(gtUint8 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Rem(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function rem(gtUint64 a, gtUint8 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Rem(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function and(gtUint8 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).And(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function and(gtUint64 a, gtUint8 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).And(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function or(gtUint8 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Or(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function or(gtUint64 a, gtUint8 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Or(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function xor(gtUint8 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Xor(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function xor(gtUint64 a, gtUint8 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Xor(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function eq(gtUint8 a, gtUint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Eq(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function eq(gtUint64 a, gtUint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Eq(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function ne(gtUint8 a, gtUint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ne(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function ne(gtUint64 a, gtUint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ne(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function ge(gtUint8 a, gtUint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ge(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function ge(gtUint64 a, gtUint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ge(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function gt(gtUint8 a, gtUint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Gt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function gt(gtUint64 a, gtUint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Gt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function le(gtUint8 a, gtUint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Le(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function le(gtUint64 a, gtUint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Le(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function lt(gtUint8 a, gtUint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Lt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function lt(gtUint64 a, gtUint8 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Lt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function min(gtUint8 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Min(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function min(gtUint64 a, gtUint8 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Min(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function max(gtUint8 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Max(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint8.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function max(gtUint64 a, gtUint8 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Max(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function mux(gtBool bit, gtUint8 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mux(
                    combineEnumsToBytes3(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtBool.unwrap(bit),
                    gtUint8.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function mux(gtBool bit, gtUint64 a, gtUint8 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mux(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                    gtBool.unwrap(bit),
                    gtUint64.unwrap(a),
                    gtUint8.unwrap(b)
                )
            );
    }

    function transfer(gtUint8 a, gtUint64 b, gtUint64 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                gtUint8.unwrap(a),
                gtUint64.unwrap(b),
                gtUint64.unwrap(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint64 a, gtUint8 b, gtUint64 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                gtUint64.unwrap(a),
                gtUint8.unwrap(b),
                gtUint64.unwrap(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint8 a, gtUint64 b, gtUint8 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                gtUint8.unwrap(a),
                gtUint64.unwrap(b),
                gtUint8.unwrap(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint64 a, gtUint8 b, gtUint8 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                gtUint64.unwrap(a),
                gtUint8.unwrap(b),
                gtUint8.unwrap(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint8 a, gtUint64 b, gtUint16 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                gtUint8.unwrap(a),
                gtUint64.unwrap(b),
                gtUint16.unwrap(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint64 a, gtUint8 b, gtUint16 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                gtUint64.unwrap(a),
                gtUint8.unwrap(b),
                gtUint16.unwrap(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint8 a, gtUint64 b, gtUint32 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                gtUint8.unwrap(a),
                gtUint64.unwrap(b),
                gtUint32.unwrap(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint64 a, gtUint8 b, gtUint32 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT8_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                gtUint64.unwrap(a),
                gtUint8.unwrap(b),
                gtUint32.unwrap(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint64 a, gtUint64 b, gtUint8 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                gtUint64.unwrap(a),
                gtUint64.unwrap(b),
                gtUint8.unwrap(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint64 b,
        gtUint8 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint8.unwrap(a),
                gtUint64.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint8 b,
        gtUint8 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint8.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint64 b,
        gtUint16 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint8.unwrap(a),
                gtUint64.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint8 b,
        gtUint16 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint8.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint64 b,
        gtUint32 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint8.unwrap(a),
                gtUint64.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint8 b,
        gtUint32 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint8.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint64 b,
        gtUint64 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint8.unwrap(a),
                gtUint64.unwrap(b),
                gtUint64.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint8 b,
        gtUint64 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint8.unwrap(b),
                gtUint64.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint64 b,
        gtUint8 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint64.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint64 b,
        gtUint64 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint64.unwrap(b),
                gtUint64.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    // Allowance with 16 bit
    function transferWithAllowance(
        gtUint8 a,
        gtUint64 b,
        gtUint8 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint8.unwrap(a),
                gtUint64.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint8 b,
        gtUint8 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint8.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint64 b,
        gtUint16 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint8.unwrap(a),
                gtUint64.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint8 b,
        gtUint16 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint8.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint64 b,
        gtUint32 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint8.unwrap(a),
                gtUint64.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint8 b,
        gtUint32 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint8.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint64 b,
        gtUint64 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint8.unwrap(a),
                gtUint64.unwrap(b),
                gtUint64.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint8 b,
        gtUint64 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint8.unwrap(b),
                gtUint64.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint64 b,
        gtUint8 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint64.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint64 b,
        gtUint64 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint64.unwrap(b),
                gtUint64.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    // Allowance with 32 bit
    function transferWithAllowance(
        gtUint8 a,
        gtUint64 b,
        gtUint8 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint8.unwrap(a),
                gtUint64.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint8 b,
        gtUint8 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint8.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint64 b,
        gtUint16 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint8.unwrap(a),
                gtUint64.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint8 b,
        gtUint16 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint8.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint64 b,
        gtUint32 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint8.unwrap(a),
                gtUint64.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint8 b,
        gtUint32 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint8.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint64 b,
        gtUint64 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint8.unwrap(a),
                gtUint64.unwrap(b),
                gtUint64.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint8 b,
        gtUint64 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint8.unwrap(b),
                gtUint64.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint64 b,
        gtUint8 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint64.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint64 b,
        gtUint64 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint64.unwrap(b),
                gtUint64.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    // Allowance with 64 bit
    function transferWithAllowance(
        gtUint8 a,
        gtUint64 b,
        gtUint8 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint8.unwrap(a),
                gtUint64.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint8 b,
        gtUint8 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint8.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint64 b,
        gtUint16 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint8.unwrap(a),
                gtUint64.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint8 b,
        gtUint16 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint8.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint64 b,
        gtUint32 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint8.unwrap(a),
                gtUint64.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint8 b,
        gtUint32 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint8.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint8 a,
        gtUint64 b,
        gtUint64 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint8.unwrap(a),
                gtUint64.unwrap(b),
                gtUint64.unwrap(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint8 b,
        gtUint64 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint8.unwrap(b),
                gtUint64.unwrap(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint64 b,
        gtUint8 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint64.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    // =========== 16 - 64 bit operations ==============

    function add(gtUint16 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Add(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function add(gtUint64 a, gtUint16 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Add(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function checkedAddWithOverflowBit(gtUint16 a, gtUint64 b) internal returns (gtBool, gtUint64) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedAdd(
            combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
            gtUint16.unwrap(a),
            gtUint64.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint64.wrap(res));
    }

    function checkedAddWithOverflowBit(gtUint64 a, gtUint16 b) internal returns (gtBool, gtUint64) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedAdd(
            combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
            gtUint64.unwrap(a),
            gtUint16.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint64.wrap(res));
    }

    function sub(gtUint16 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Sub(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function sub(gtUint64 a, gtUint16 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Sub(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function checkedSubWithOverflowBit(gtUint16 a, gtUint64 b) internal returns (gtBool, gtUint64) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedSub(
            combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
            gtUint16.unwrap(a),
            gtUint64.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint64.wrap(res));
    }

    function checkedSubWithOverflowBit(gtUint64 a, gtUint16 b) internal returns (gtBool, gtUint64) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedSub(
            combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
            gtUint64.unwrap(a),
            gtUint16.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint64.wrap(res));
    }

    function mul(gtUint16 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mul(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function mul(gtUint64 a, gtUint16 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mul(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function checkedMulWithOverflowBit(gtUint16 a, gtUint64 b) internal returns (gtBool, gtUint64) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedMul(
            combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
            gtUint16.unwrap(a),
            gtUint64.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint64.wrap(res));
    }

    function checkedMulWithOverflowBit(gtUint64 a, gtUint16 b) internal returns (gtBool, gtUint64) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedMul(
            combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
            gtUint64.unwrap(a),
            gtUint16.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint64.wrap(res));
    }

    function div(gtUint16 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Div(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function div(gtUint64 a, gtUint16 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Div(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function rem(gtUint16 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Rem(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function rem(gtUint64 a, gtUint16 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Rem(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function and(gtUint16 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).And(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function and(gtUint64 a, gtUint16 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).And(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function or(gtUint16 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Or(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function or(gtUint64 a, gtUint16 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Or(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function xor(gtUint16 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Xor(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function xor(gtUint64 a, gtUint16 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Xor(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function eq(gtUint16 a, gtUint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Eq(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function eq(gtUint64 a, gtUint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Eq(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function ne(gtUint16 a, gtUint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ne(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function ne(gtUint64 a, gtUint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ne(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function ge(gtUint16 a, gtUint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ge(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function ge(gtUint64 a, gtUint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ge(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function gt(gtUint16 a, gtUint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Gt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function gt(gtUint64 a, gtUint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Gt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function le(gtUint16 a, gtUint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Le(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function le(gtUint64 a, gtUint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Le(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function lt(gtUint16 a, gtUint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Lt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function lt(gtUint64 a, gtUint16 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Lt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function min(gtUint16 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Min(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function min(gtUint64 a, gtUint16 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Min(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function max(gtUint16 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Max(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint16.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function max(gtUint64 a, gtUint16 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Max(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function mux(gtBool bit, gtUint16 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mux(
                    combineEnumsToBytes3(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtBool.unwrap(bit),
                    gtUint16.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function mux(gtBool bit, gtUint64 a, gtUint16 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mux(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                    gtBool.unwrap(bit),
                    gtUint64.unwrap(a),
                    gtUint16.unwrap(b)
                )
            );
    }

    function transfer(gtUint16 a, gtUint64 b, gtUint64 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                gtUint16.unwrap(a),
                gtUint64.unwrap(b),
                gtUint64.unwrap(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint64 a, gtUint16 b, gtUint64 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                gtUint64.unwrap(a),
                gtUint16.unwrap(b),
                gtUint64.unwrap(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint16 a, gtUint64 b, gtUint8 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                gtUint16.unwrap(a),
                gtUint64.unwrap(b),
                gtUint8.unwrap(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint64 a, gtUint16 b, gtUint8 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                gtUint64.unwrap(a),
                gtUint16.unwrap(b),
                gtUint8.unwrap(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint16 a, gtUint64 b, gtUint16 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                gtUint16.unwrap(a),
                gtUint64.unwrap(b),
                gtUint16.unwrap(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint64 a, gtUint16 b, gtUint16 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                gtUint64.unwrap(a),
                gtUint16.unwrap(b),
                gtUint16.unwrap(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint16 a, gtUint64 b, gtUint32 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                gtUint16.unwrap(a),
                gtUint64.unwrap(b),
                gtUint32.unwrap(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint64 a, gtUint16 b, gtUint32 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT16_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                gtUint64.unwrap(a),
                gtUint16.unwrap(b),
                gtUint32.unwrap(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint64 a, gtUint64 b, gtUint16 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                gtUint64.unwrap(a),
                gtUint64.unwrap(b),
                gtUint16.unwrap(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint64 b,
        gtUint8 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint64.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint16 b,
        gtUint8 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint16.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint64 b,
        gtUint16 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint64.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint16 b,
        gtUint16 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint16.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint64 b,
        gtUint32 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint64.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint16 b,
        gtUint32 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint16.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint64 b,
        gtUint64 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint64.unwrap(b),
                gtUint64.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint16 b,
        gtUint64 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint16.unwrap(b),
                gtUint64.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint64 b,
        gtUint16 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint64.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    // Allowance with 16 bit
    function transferWithAllowance(
        gtUint16 a,
        gtUint64 b,
        gtUint8 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint64.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint16 b,
        gtUint8 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint16.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint64 b,
        gtUint16 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint64.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint16 b,
        gtUint16 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint16.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint64 b,
        gtUint32 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint64.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint16 b,
        gtUint32 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint16.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint64 b,
        gtUint64 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint64.unwrap(b),
                gtUint64.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint16 b,
        gtUint64 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint16.unwrap(b),
                gtUint64.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint64 b,
        gtUint16 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint64.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    // Allowance with 32 bit
    function transferWithAllowance(
        gtUint16 a,
        gtUint64 b,
        gtUint8 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint64.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint16 b,
        gtUint8 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint16.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint64 b,
        gtUint16 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint64.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint16 b,
        gtUint16 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint16.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint64 b,
        gtUint32 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint64.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint16 b,
        gtUint32 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint16.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint64 b,
        gtUint64 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint64.unwrap(b),
                gtUint64.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint16 b,
        gtUint64 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint16.unwrap(b),
                gtUint64.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint64 b,
        gtUint16 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint64.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    // Allowance with 64 bit
    function transferWithAllowance(
        gtUint16 a,
        gtUint64 b,
        gtUint8 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint64.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint16 b,
        gtUint8 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint16.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint64 b,
        gtUint16 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint64.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint16 b,
        gtUint16 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint16.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint64 b,
        gtUint32 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint64.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint16 b,
        gtUint32 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint16.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint16 a,
        gtUint64 b,
        gtUint64 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint16.unwrap(a),
                gtUint64.unwrap(b),
                gtUint64.unwrap(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint16 b,
        gtUint64 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint16.unwrap(b),
                gtUint64.unwrap(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint64 b,
        gtUint16 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint64.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    // =========== 32 - 64 bit operations ==============

    function add(gtUint32 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Add(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function add(gtUint64 a, gtUint32 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Add(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function checkedAddWithOverflowBit(gtUint32 a, gtUint64 b) internal returns (gtBool, gtUint64) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedAdd(
            combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
            gtUint32.unwrap(a),
            gtUint64.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint64.wrap(res));
    }

    function checkedAddWithOverflowBit(gtUint64 a, gtUint32 b) internal returns (gtBool, gtUint64) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedAdd(
            combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
            gtUint64.unwrap(a),
            gtUint32.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint64.wrap(res));
    }

    function sub(gtUint32 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Sub(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function sub(gtUint64 a, gtUint32 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Sub(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function checkedSubWithOverflowBit(gtUint32 a, gtUint64 b) internal returns (gtBool, gtUint64) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedSub(
            combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
            gtUint32.unwrap(a),
            gtUint64.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint64.wrap(res));
    }

    function checkedSubWithOverflowBit(gtUint64 a, gtUint32 b) internal returns (gtBool, gtUint64) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedSub(
            combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
            gtUint64.unwrap(a),
            gtUint32.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint64.wrap(res));
    }

    function mul(gtUint32 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mul(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function mul(gtUint64 a, gtUint32 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mul(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function checkedMulWithOverflowBit(gtUint32 a, gtUint64 b) internal returns (gtBool, gtUint64) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedMul(
            combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
            gtUint32.unwrap(a),
            gtUint64.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint64.wrap(res));
    }

    function checkedMulWithOverflowBit(gtUint64 a, gtUint32 b) internal returns (gtBool, gtUint64) {
        (uint256 bit, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress)).CheckedMul(
            combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
            gtUint64.unwrap(a),
            gtUint32.unwrap(b)
        );

        return (gtBool.wrap(bit), gtUint64.wrap(res));
    }

    function div(gtUint32 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Div(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function div(gtUint64 a, gtUint32 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Div(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function rem(gtUint32 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Rem(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function rem(gtUint64 a, gtUint32 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Rem(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function and(gtUint32 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).And(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function and(gtUint64 a, gtUint32 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).And(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function or(gtUint32 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Or(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function or(gtUint64 a, gtUint32 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Or(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function xor(gtUint32 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Xor(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function xor(gtUint64 a, gtUint32 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Xor(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function eq(gtUint32 a, gtUint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Eq(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function eq(gtUint64 a, gtUint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Eq(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function ne(gtUint32 a, gtUint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ne(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function ne(gtUint64 a, gtUint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ne(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function ge(gtUint32 a, gtUint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ge(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function ge(gtUint64 a, gtUint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Ge(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function gt(gtUint32 a, gtUint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Gt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function gt(gtUint64 a, gtUint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Gt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function le(gtUint32 a, gtUint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Le(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function le(gtUint64 a, gtUint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Le(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function lt(gtUint32 a, gtUint64 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Lt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function lt(gtUint64 a, gtUint32 b) internal returns (gtBool) {
        return
            gtBool.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Lt(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function min(gtUint32 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Min(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function min(gtUint64 a, gtUint32 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Min(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function max(gtUint32 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Max(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtUint32.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function max(gtUint64 a, gtUint32 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Max(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtUint64.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function mux(gtBool bit, gtUint32 a, gtUint64 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mux(
                    combineEnumsToBytes3(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                    gtBool.unwrap(bit),
                    gtUint32.unwrap(a),
                    gtUint64.unwrap(b)
                )
            );
    }

    function mux(gtBool bit, gtUint64 a, gtUint32 b) internal returns (gtUint64) {
        return
            gtUint64.wrap(
                GCExtendedOperations(address(GCExtendedOperationsAddress)).Mux(
                    combineEnumsToBytes3(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                    gtBool.unwrap(bit),
                    gtUint64.unwrap(a),
                    gtUint32.unwrap(b)
                )
            );
    }

    function transfer(gtUint32 a, gtUint64 b, gtUint64 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                gtUint32.unwrap(a),
                gtUint64.unwrap(b),
                gtUint64.unwrap(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint64 a, gtUint32 b, gtUint64 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT64_T, ARGS.BOTH_SECRET),
                gtUint64.unwrap(a),
                gtUint32.unwrap(b),
                gtUint64.unwrap(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint32 a, gtUint64 b, gtUint8 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                gtUint32.unwrap(a),
                gtUint64.unwrap(b),
                gtUint8.unwrap(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint64 a, gtUint32 b, gtUint8 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT8_T, ARGS.BOTH_SECRET),
                gtUint64.unwrap(a),
                gtUint32.unwrap(b),
                gtUint8.unwrap(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint32 a, gtUint64 b, gtUint16 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                gtUint32.unwrap(a),
                gtUint64.unwrap(b),
                gtUint16.unwrap(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint64 a, gtUint32 b, gtUint16 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT16_T, ARGS.BOTH_SECRET),
                gtUint64.unwrap(a),
                gtUint32.unwrap(b),
                gtUint16.unwrap(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint32 a, gtUint64 b, gtUint32 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                gtUint32.unwrap(a),
                gtUint64.unwrap(b),
                gtUint32.unwrap(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint64 a, gtUint32 b, gtUint32 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT32_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                gtUint64.unwrap(a),
                gtUint32.unwrap(b),
                gtUint32.unwrap(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transfer(gtUint64 a, gtUint64 b, gtUint32 amount) internal returns (gtUint64, gtUint64, gtBool) {
        (uint256 new_a, uint256 new_b, uint256 res) = GCExtendedOperations(address(GCExtendedOperationsAddress))
            .Transfer(
                combineEnumsToBytes4(MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT64_T, MPC_TYPE.SUINT32_T, ARGS.BOTH_SECRET),
                gtUint64.unwrap(a),
                gtUint64.unwrap(b),
                gtUint32.unwrap(amount)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint64 b,
        gtUint8 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint64.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint32 b,
        gtUint8 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint32.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint64 b,
        gtUint16 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint64.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint32 b,
        gtUint16 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint32.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint64 b,
        gtUint32 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint64.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint32 b,
        gtUint32 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint32.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint64 b,
        gtUint64 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint64.unwrap(b),
                gtUint64.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint32 b,
        gtUint64 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint32.unwrap(b),
                gtUint64.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint64 b,
        gtUint32 amount,
        gtUint8 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint64.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint8.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    // Allowance with 16 bit
    function transferWithAllowance(
        gtUint32 a,
        gtUint64 b,
        gtUint8 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint64.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint32 b,
        gtUint8 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint32.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint64 b,
        gtUint16 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint64.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint32 b,
        gtUint16 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint32.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint64 b,
        gtUint32 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint64.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint32 b,
        gtUint32 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint32.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint64 b,
        gtUint64 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint64.unwrap(b),
                gtUint64.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint32 b,
        gtUint64 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint32.unwrap(b),
                gtUint64.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint64 b,
        gtUint32 amount,
        gtUint16 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint64.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint16.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    // Allowance with 32 bit
    function transferWithAllowance(
        gtUint32 a,
        gtUint64 b,
        gtUint8 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint64.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint32 b,
        gtUint8 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint32.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint64 b,
        gtUint16 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint64.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint32 b,
        gtUint16 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint32.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint64 b,
        gtUint32 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint64.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint32 b,
        gtUint32 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint32.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint64 b,
        gtUint64 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint64.unwrap(b),
                gtUint64.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint32 b,
        gtUint64 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint32.unwrap(b),
                gtUint64.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint64 b,
        gtUint32 amount,
        gtUint32 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint64.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint32.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    // Allowance with 64 bit
    function transferWithAllowance(
        gtUint32 a,
        gtUint64 b,
        gtUint8 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint64.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint32 b,
        gtUint8 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT8_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint32.unwrap(b),
                gtUint8.unwrap(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint64 b,
        gtUint16 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint64.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint32 b,
        gtUint16 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT16_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint32.unwrap(b),
                gtUint16.unwrap(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint64 b,
        gtUint32 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint64.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint32 b,
        gtUint32 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint32.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint32 a,
        gtUint64 b,
        gtUint64 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint32.unwrap(a),
                gtUint64.unwrap(b),
                gtUint64.unwrap(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint32 b,
        gtUint64 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint32.unwrap(b),
                gtUint64.unwrap(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }

    function transferWithAllowance(
        gtUint64 a,
        gtUint64 b,
        gtUint32 amount,
        gtUint64 allowance
    ) internal returns (gtUint64, gtUint64, gtBool, gtUint64) {
        (uint256 new_a, uint256 new_b, uint256 res, uint256 new_allowance) = GCExtendedOperations(
            address(GCExtendedOperationsAddress)
        ).TransferWithAllowance(
                combineEnumsToBytes5(
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT64_T,
                    MPC_TYPE.SUINT32_T,
                    MPC_TYPE.SUINT64_T,
                    ARGS.BOTH_SECRET
                ),
                gtUint64.unwrap(a),
                gtUint64.unwrap(b),
                gtUint32.unwrap(amount),
                gtUint64.unwrap(allowance)
            );
        return (gtUint64.wrap(new_a), gtUint64.wrap(new_b), gtBool.wrap(res), gtUint64.wrap(new_allowance));
    }
}
