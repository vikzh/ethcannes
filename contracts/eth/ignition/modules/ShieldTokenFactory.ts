import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("ShieldedTokenFactoryModule", (m) => {
  const factory = m.contract("ShieldedTokenFactory");
  return { factory };
});
