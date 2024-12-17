import { ethers, upgrades } from "hardhat";

export const UpgradeERC721Module = async () => {
  const UpgradeERC721Factory = await ethers.getContractFactory("UpgradeERC721");

  const proxy = await upgrades.deployProxy(UpgradeERC721Factory, [
    "UpgradeERC721",
    "UGE",
    "https://example.com/api/metadata/",
  ], {
    initializer: "initialize",
      kind: "transparent",
    }
  );

    console.log("proxy", proxy.target);

  await proxy.mint("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266");
  const balance = await proxy.balanceOf("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266");
  console.log("balance", balance);
  const owner = await proxy.ownerOf(0);
  console.log("owner", owner);

  return { proxy };
};

UpgradeERC721Module().then((result) => {
  console.log("result", result);
});
