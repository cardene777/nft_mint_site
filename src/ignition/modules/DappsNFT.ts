import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const DappsNFTModule = buildModule("DappsNFTModule", (m) => {
  const defaultAdmin = m.getParameter("admin", "");

  if (!defaultAdmin) {
    throw new Error("defaultAdmin is required");
  }

  const dappsNft = m.contract("DappsNft", [defaultAdmin, defaultAdmin]);

  return { dappsNft };
});

export default DappsNFTModule;
