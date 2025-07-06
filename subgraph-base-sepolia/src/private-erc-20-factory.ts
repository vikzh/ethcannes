import { TokenCreated as TokenCreatedEvent } from "../generated/PrivateERC20Factory/PrivateERC20Factory"
import { PrivateERC20Factory, PrivateERC20Token, TokenCreated } from "../generated/schema"
import { PrivateERC20Contract } from "../generated/templates"
import { Address, BigInt } from "@graphprotocol/graph-ts"

export function handleTokenCreated(event: TokenCreatedEvent): void {
  // Load or create factory entity
  let factory = PrivateERC20Factory.load(event.address)
  if (factory == null) {
    factory = new PrivateERC20Factory(event.address)
    factory.totalTokensCreated = BigInt.fromI32(0)
    factory.blockNumber = event.block.number
    factory.blockTimestamp = event.block.timestamp
    factory.transactionHash = event.transaction.hash
  }
  
  // Update factory stats
  factory.totalTokensCreated = factory.totalTokensCreated.plus(BigInt.fromI32(1))
  factory.save()

  // Create token entity
  let token = new PrivateERC20Token(event.params.token)
  token.name = event.params.name
  token.symbol = event.params.symbol
  token.underlying = event.params.underlying
  token.creator = event.params.creator
  token.factory = factory.id
  token.createdAtBlock = event.block.number
  token.createdAtTimestamp = event.block.timestamp
  token.creationTransactionHash = event.transaction.hash
  token.save()

  // Create TokenCreated event entity
  let tokenCreatedEntity = new TokenCreated(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  tokenCreatedEntity.token = event.params.token
  tokenCreatedEntity.name = event.params.name
  tokenCreatedEntity.symbol = event.params.symbol
  tokenCreatedEntity.underlying = event.params.underlying
  tokenCreatedEntity.creator = event.params.creator
  tokenCreatedEntity.factory = factory.id
  tokenCreatedEntity.blockNumber = event.block.number
  tokenCreatedEntity.blockTimestamp = event.block.timestamp
  tokenCreatedEntity.transactionHash = event.transaction.hash
  tokenCreatedEntity.save()

  // Instantiate the template to start indexing the new token contract
  PrivateERC20Contract.create(Address.fromBytes(event.params.token))
} 