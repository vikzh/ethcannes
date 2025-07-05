// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./MpcCore.sol";

abstract contract DecryptionCaller {

    /// @notice Emitted when the decryption fails
    /// @param expected The expected size
    /// @param received The received size
    event InvalidDecryptSize(uint256 expected, uint256 received);

    /// @notice Emitted when the decryption is successful
    /// @param decryptID The ID of the decryption
    event SuccessDecryption(uint256 decryptID);

    /// @notice Emitted when the decryption ID already exists
    /// @param decryptID The ID of the decryption
    error DecryptionIDAlreadyExists(uint256 decryptID);

    /// @notice Emitted when the decryption ID does not exist
    /// @param decryptID The ID of the decryption
    error DecryptionIDDoesNotExist(uint256 decryptID);

    /// @notice The counter of the decryption for this contract
    uint256 decryptCounter;

    /// @notice The mapping of the handles of the decryption corresponding to the decryptID
    mapping(uint256 => uint256[]) decryptHandles;

    /// @notice Request the decryption of the handles
    /// @param handles The handles to decrypt
    /// @param callbackSelector The callback selector
    /// @return decryptID The ID of the decryption
    function requestDecryption(
        uint256[] memory handles,
        bytes4 callbackSelector
    ) internal returns (uint256 decryptID) {
        decryptID = decryptCounter;
        saveDecryptHandles(decryptID, handles);
        MpcCore.requestDecryption(decryptID, handles, callbackSelector);
        decryptCounter++;
    }

    /// @notice Save the handles to the mapping of the handles of the decryption corresponding to the decryptID
    /// @param decryptID The ID of the decryption
    /// @param handles The handles to save
    function saveDecryptHandles(uint256 decryptID, uint256[] memory handles) internal {
        require(handles.length > 0, "Handles array cannot be empty");

        if (decryptHandles[decryptID].length > 0) {
            revert DecryptionIDAlreadyExists(decryptID);
        }
        decryptHandles[decryptID]= handles;
    }

    /// @notice Get the handles of the decryption corresponding to the decryptID
    /// @param decryptID The ID of the decryption
    /// @return The handles of the decryption
    function getDecryptHandles(uint256 decryptID) internal view returns (uint256[] memory) {
        if (decryptHandles[decryptID].length == 0) {
            revert DecryptionIDDoesNotExist(decryptID);
        }
        return decryptHandles[decryptID];
    }

    /// @notice Check if the size of the output is the same as the size of the handles of the decryption corresponding to the decryptID
    /// @param decryptID The ID of the decryption
    /// @param size The size of the output
    /// @return True if the size of the output is the same as the size of the handles of the decryption corresponding to the decryptID, false otherwise
    function checkCallbackHandles(uint256 decryptID, uint256 size) internal returns (bool){
        uint256[] memory expectedHandles = getDecryptHandles(decryptID);
        if (expectedHandles.length != size) {
            emit InvalidDecryptSize(expectedHandles.length, size);
            return false;
        }
        emit SuccessDecryption(decryptID);
        return true;
    }


}