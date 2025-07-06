import {
  Approval as ApprovalEvent,
  Approval1 as Approval1Event,
  InvalidDecryptSize as InvalidDecryptSizeEvent,
  Shield as ShieldEvent,
  SuccessDecryption as SuccessDecryptionEvent,
  Transfer as TransferEvent,
  Transfer1 as Transfer1Event,
  Unshield as UnshieldEvent,
  UnshieldFailed as UnshieldFailedEvent,
  UnshieldRequested as UnshieldRequestedEvent
} from "../generated/PrivateERC20Contract/PrivateERC20Contract"
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
  UnshieldRequested,
  PrivateERC20Token
} from "../generated/schema"
import { dataSource } from "@graphprotocol/graph-ts"

export function handleApproval(event: ApprovalEvent): void {
  let entity = new Approval(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.token = dataSource.address()
  entity._owner = event.params._owner
  entity._spender = event.params._spender
  entity._value = event.params._value

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleApproval1(event: Approval1Event): void {
  let entity = new Approval1(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.token = dataSource.address()
  entity._owner = event.params._owner
  entity._spender = event.params._spender

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleInvalidDecryptSize(event: InvalidDecryptSizeEvent): void {
  let entity = new InvalidDecryptSize(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.token = dataSource.address()
  entity.expected = event.params.expected
  entity.received = event.params.received

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleShield(event: ShieldEvent): void {
  let entity = new Shield(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.token = dataSource.address()
  entity.from = event.params.from
  entity.amount = event.params.amount

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleSuccessDecryption(event: SuccessDecryptionEvent): void {
  let entity = new SuccessDecryption(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.token = dataSource.address()
  entity.decryptID = event.params.decryptID

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleTransfer(event: TransferEvent): void {
  let entity = new Transfer(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.token = dataSource.address()
  entity._from = event.params._from
  entity._to = event.params._to
  entity._value = event.params._value

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleTransfer1(event: Transfer1Event): void {
  let entity = new Transfer1(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.token = dataSource.address()
  entity._from = event.params._from
  entity._to = event.params._to

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleUnshield(event: UnshieldEvent): void {
  let entity = new Unshield(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.token = dataSource.address()
  entity.to = event.params.to
  entity.amount = event.params.amount

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleUnshieldFailed(event: UnshieldFailedEvent): void {
  let entity = new UnshieldFailed(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.token = dataSource.address()
  entity.to = event.params.to
  entity.amount = event.params.amount

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleUnshieldRequested(event: UnshieldRequestedEvent): void {
  let entity = new UnshieldRequested(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.token = dataSource.address()
  entity.to = event.params.to
  entity.amount = event.params.amount

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}
