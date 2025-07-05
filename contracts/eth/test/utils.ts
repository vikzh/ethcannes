import {ethers} from "ethers";
import {encrypt} from "soda-sdk";

/**
 * Prepares a message specifically for ValidateCiphertext function by encrypting the plaintext
 * and constructing the message in the format expected by ValidateCiphertext.
 * @param {bigint} plaintext - The plaintext value to be encrypted as a BigInt.
 * @param {string} signerAddress - The address of the signer (Ethereum address).
 * @param {string} aesKey - The AES key used for encryption (16 bytes as a hex string).
 * @param {string} contractAddress - The address of the contract (Ethereum address).
 * @returns {Object} - An object containing the encrypted integer and the message bytes.
 * @throws {TypeError} - Throws if any of the input parameters are of invalid types or have incorrect lengths.
 */
export function prepareMessageForBubble(
  plaintext: bigint,
  signerAddress: string,
  aesKey: string,
  contractAddress: string
): {
  encryptedInt: bigint;
  messageBytes: Uint8Array;
} {
    // Validate signerAddress (Ethereum address)
    if (!ethers.isAddress(signerAddress)) {
        throw new TypeError("Invalid signer address");
    }

    // Validate aesKey (16 bytes as hex string for ValidateCiphertext)
    if (typeof aesKey !== "string" || aesKey.length !== 32) {
        throw new TypeError("Invalid AES key length. Expected 16 bytes as hex string (32 characters).");
    }

    // Validate contractAddress (Ethereum address)
    if (typeof contractAddress !== "string" || !ethers.isAddress(contractAddress)) {
        throw new TypeError("Invalid contract address");
    }

    // Convert the plaintext to bytes
    const plaintextBytes = Buffer.alloc(8); // Allocate a buffer of size 8 bytes
    plaintextBytes.writeBigUInt64BE(plaintext); // Write the uint64 value to the buffer as little-endian

    // Encrypt the plaintext using AES key
    const { ciphertext, r } = encrypt(Buffer.from(aesKey, 'hex'), plaintextBytes);
    const ct = Buffer.concat([ciphertext, r]);

    // Convert the ciphertext to BigInt
    const encryptedInt = BigInt("0x" + ct.toString("hex"));

    // Create the message bytes in the format expected by ValidateCiphertext:
    // abi.encodePacked(tx.origin, msg.sender, ciphertext)
    // Note: When calling ValidateCiphertext directly, tx.origin and msg.sender are usually the same
    const messageBytes = ethers.solidityPacked(
        ["address", "address", "uint256"],
        [signerAddress, contractAddress, encryptedInt]
    );

    return { encryptedInt, messageBytes: ethers.getBytes(messageBytes) };
}