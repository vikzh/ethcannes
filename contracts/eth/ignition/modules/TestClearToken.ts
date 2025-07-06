import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("ClearTokenModule", (m) => {
  const clearToken = m.contract("ClearToken", ["testUSDC", "testClearToken"]);

  return { clearToken };
});
