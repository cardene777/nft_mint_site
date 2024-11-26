import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const metaTransactionContract: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  // Deploy TrustedForwarder
  const trustedForwarder = await deploy("TrustedForwarder", {
    from: deployer,
    args: ["TrustedForwarder"],
    log: true,
    autoMine: true,
  });

  // Deploy MetaTransactionNFT

  await deploy("MetaTransactionNFT", {
    from: deployer,
    args: [trustedForwarder.address],
    log: true,
    autoMine: true,
  });
};

export default metaTransactionContract;

metaTransactionContract.tags = ["MetaTransactionNFT"];
