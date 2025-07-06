import { newMockEvent } from "matchstick-as"
import { ethereum, Address, BigInt } from "@graphprotocol/graph-ts"
import {
  Approval,
  Approval1,
  InvalidDecryptSize,
  Shield,
  SuccessDecryption,
  Transfer,
  Transfer1,
  Unshield,
  UnshieldFailed,
  UnshieldRequested
} from "../generated/PrivateERC20Contract/PrivateERC20Contract"

export function createApprovalEvent(
  _owner: Address,
  _spender: Address,
  _value: BigInt
): Approval {
  let approvalEvent = changetype<Approval>(newMockEvent())

  approvalEvent.parameters = new Array()

  approvalEvent.parameters.push(
    new ethereum.EventParam("_owner", ethereum.Value.fromAddress(_owner))
  )
  approvalEvent.parameters.push(
    new ethereum.EventParam("_spender", ethereum.Value.fromAddress(_spender))
  )
  approvalEvent.parameters.push(
    new ethereum.EventParam("_value", ethereum.Value.fromUnsignedBigInt(_value))
  )

  return approvalEvent
}

export function createApproval1Event(
  _owner: Address,
  _spender: Address
): Approval1 {
  let approval1Event = changetype<Approval1>(newMockEvent())

  approval1Event.parameters = new Array()

  approval1Event.parameters.push(
    new ethereum.EventParam("_owner", ethereum.Value.fromAddress(_owner))
  )
  approval1Event.parameters.push(
    new ethereum.EventParam("_spender", ethereum.Value.fromAddress(_spender))
  )

  return approval1Event
}

export function createInvalidDecryptSizeEvent(
  expected: BigInt,
  received: BigInt
): InvalidDecryptSize {
  let invalidDecryptSizeEvent = changetype<InvalidDecryptSize>(newMockEvent())

  invalidDecryptSizeEvent.parameters = new Array()

  invalidDecryptSizeEvent.parameters.push(
    new ethereum.EventParam(
      "expected",
      ethereum.Value.fromUnsignedBigInt(expected)
    )
  )
  invalidDecryptSizeEvent.parameters.push(
    new ethereum.EventParam(
      "received",
      ethereum.Value.fromUnsignedBigInt(received)
    )
  )

  return invalidDecryptSizeEvent
}

export function createShieldEvent(from: Address, amount: BigInt): Shield {
  let shieldEvent = changetype<Shield>(newMockEvent())

  shieldEvent.parameters = new Array()

  shieldEvent.parameters.push(
    new ethereum.EventParam("from", ethereum.Value.fromAddress(from))
  )
  shieldEvent.parameters.push(
    new ethereum.EventParam("amount", ethereum.Value.fromUnsignedBigInt(amount))
  )

  return shieldEvent
}

export function createSuccessDecryptionEvent(
  decryptID: BigInt
): SuccessDecryption {
  let successDecryptionEvent = changetype<SuccessDecryption>(newMockEvent())

  successDecryptionEvent.parameters = new Array()

  successDecryptionEvent.parameters.push(
    new ethereum.EventParam(
      "decryptID",
      ethereum.Value.fromUnsignedBigInt(decryptID)
    )
  )

  return successDecryptionEvent
}

export function createTransferEvent(
  _from: Address,
  _to: Address,
  _value: BigInt
): Transfer {
  let transferEvent = changetype<Transfer>(newMockEvent())

  transferEvent.parameters = new Array()

  transferEvent.parameters.push(
    new ethereum.EventParam("_from", ethereum.Value.fromAddress(_from))
  )
  transferEvent.parameters.push(
    new ethereum.EventParam("_to", ethereum.Value.fromAddress(_to))
  )
  transferEvent.parameters.push(
    new ethereum.EventParam("_value", ethereum.Value.fromUnsignedBigInt(_value))
  )

  return transferEvent
}

export function createTransfer1Event(_from: Address, _to: Address): Transfer1 {
  let transfer1Event = changetype<Transfer1>(newMockEvent())

  transfer1Event.parameters = new Array()

  transfer1Event.parameters.push(
    new ethereum.EventParam("_from", ethereum.Value.fromAddress(_from))
  )
  transfer1Event.parameters.push(
    new ethereum.EventParam("_to", ethereum.Value.fromAddress(_to))
  )

  return transfer1Event
}

export function createUnshieldEvent(to: Address, amount: BigInt): Unshield {
  let unshieldEvent = changetype<Unshield>(newMockEvent())

  unshieldEvent.parameters = new Array()

  unshieldEvent.parameters.push(
    new ethereum.EventParam("to", ethereum.Value.fromAddress(to))
  )
  unshieldEvent.parameters.push(
    new ethereum.EventParam("amount", ethereum.Value.fromUnsignedBigInt(amount))
  )

  return unshieldEvent
}

export function createUnshieldFailedEvent(
  to: Address,
  amount: BigInt
): UnshieldFailed {
  let unshieldFailedEvent = changetype<UnshieldFailed>(newMockEvent())

  unshieldFailedEvent.parameters = new Array()

  unshieldFailedEvent.parameters.push(
    new ethereum.EventParam("to", ethereum.Value.fromAddress(to))
  )
  unshieldFailedEvent.parameters.push(
    new ethereum.EventParam("amount", ethereum.Value.fromUnsignedBigInt(amount))
  )

  return unshieldFailedEvent
}

export function createUnshieldRequestedEvent(
  to: Address,
  amount: BigInt
): UnshieldRequested {
  let unshieldRequestedEvent = changetype<UnshieldRequested>(newMockEvent())

  unshieldRequestedEvent.parameters = new Array()

  unshieldRequestedEvent.parameters.push(
    new ethereum.EventParam("to", ethereum.Value.fromAddress(to))
  )
  unshieldRequestedEvent.parameters.push(
    new ethereum.EventParam("amount", ethereum.Value.fromUnsignedBigInt(amount))
  )

  return unshieldRequestedEvent
}
