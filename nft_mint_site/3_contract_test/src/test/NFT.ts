import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import hre from "hardhat";

describe("DappsNft", function () {
  async function deployDappsNftFixture() {
    const [admin, pauser, otherAccount] = await hre.ethers.getSigners();

    const DappsNft = await hre.ethers.getContractFactory("DappsNft");
    const dappsNft = await DappsNft.deploy(admin.address, pauser.address);

    return { dappsNft, admin, pauser, otherAccount };
  }

  describe("Deployment", function () {
    it("Should set the right roles", async function () {
      const { dappsNft, admin, pauser } = await loadFixture(
        deployDappsNftFixture
      );

      expect(
        await dappsNft.hasRole(
          await dappsNft.DEFAULT_ADMIN_ROLE(),
          admin.address
        )
      ).to.be.true;
      expect(
        await dappsNft.hasRole(await dappsNft.PAUSER_ROLE(), pauser.address)
      ).to.be.true;
    });
  });

  describe("Minting", function () {
    it("Should mint a new token and set token URI", async function () {
      const { dappsNft, admin, otherAccount } = await loadFixture(
        deployDappsNftFixture
      );
      const tokenURI = "https://example.com";

      await expect(dappsNft.safeMint(otherAccount.address, tokenURI)).to.emit(
        dappsNft,
        "Transfer"
      );

      const tokenId = 0;
      expect(await dappsNft.ownerOf(tokenId)).to.equal(otherAccount.address);
      expect(await dappsNft.tokenURI(tokenId)).to.equal(tokenURI);
    });
  });

  describe("Pausable", function () {
    it("Should pause and unpause the contract by pauser", async function () {
      const { dappsNft, pauser } = await loadFixture(deployDappsNftFixture);

      // Pausing the contract
      await dappsNft.connect(pauser).pause();
      expect(await dappsNft.paused()).to.be.true;

      // Trying to mint while paused should fail with custom error EnforcedPause
      await expect(
        dappsNft.safeMint(pauser.address, "https://example.com")
      ).to.be.revertedWithCustomError(dappsNft, "EnforcedPause");

      // Unpausing the contract
      await dappsNft.connect(pauser).unpause();
      expect(await dappsNft.paused()).to.be.false;

      // Minting should succeed after unpausing
      await expect(
        dappsNft.safeMint(pauser.address, "https://example.com")
      ).to.emit(dappsNft, "Transfer");
    });

    it("Should fail to pause/unpause if not the pauser", async function () {
      const { dappsNft, otherAccount } = await loadFixture(
        deployDappsNftFixture
      );

      // Trying to pause with a non-pauser account should fail
      await expect(
        dappsNft.connect(otherAccount).pause()
      ).to.be.revertedWithCustomError(
        dappsNft,
        "AccessControlUnauthorizedAccount"
      );
    });

    it("Should revert with ExpectedPause when calling unpause while not paused", async function () {
      const { dappsNft, pauser } = await loadFixture(deployDappsNftFixture);

      // Trying to unpause when the contract is not paused
      await expect(
        dappsNft.connect(pauser).unpause()
      ).to.be.revertedWithCustomError(dappsNft, "ExpectedPause");
    });
  });

  describe("Transfers", function () {
    it("Should transfer token between accounts", async function () {
      const { dappsNft, admin, otherAccount } = await loadFixture(
        deployDappsNftFixture
      );
      const tokenURI = "https://example.com";

      await dappsNft.safeMint(admin.address, tokenURI);
      const tokenId = 0;

      // Transfer token from admin to otherAccount
      await expect(
        dappsNft.transferFrom(admin.address, otherAccount.address, tokenId)
      )
        .to.emit(dappsNft, "Transfer")
        .withArgs(admin.address, otherAccount.address, tokenId);

      expect(await dappsNft.ownerOf(tokenId)).to.equal(otherAccount.address);
    });

    it("Should fail to transfer token from non-owner", async function () {
      const { dappsNft, admin, otherAccount } = await loadFixture(
        deployDappsNftFixture
      );
      const tokenURI = "https://example.com";

      await dappsNft.safeMint(admin.address, tokenURI);
      const tokenId = 0;

      await expect(
        dappsNft
          .connect(otherAccount)
          .transferFrom(admin.address, otherAccount.address, tokenId)
      ).to.be.revertedWithCustomError(dappsNft, "ERC721InsufficientApproval");
    });
  });

  describe("Burnable", function () {
    it("Should burn a token", async function () {
      const { dappsNft, admin } = await loadFixture(deployDappsNftFixture);
      const tokenURI = "https://example.com";

      await dappsNft.safeMint(admin.address, tokenURI);
      const tokenId = 0;

      // Burn the token
      await expect(dappsNft.burn(tokenId))
        .to.emit(dappsNft, "Transfer")
        .withArgs(admin.address, hre.ethers.ZeroAddress, tokenId);

      await expect(dappsNft.ownerOf(tokenId)).to.be.revertedWithCustomError(
        dappsNft,
        "ERC721NonexistentToken"
      );
    });
  });
});
