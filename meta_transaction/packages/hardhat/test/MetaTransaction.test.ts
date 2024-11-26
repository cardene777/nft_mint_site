import { SignerWithAddress } from "@nomicfoundation/hardhat-ethers/signers";
import { expect } from "chai";
import { ethers } from "hardhat";
import type { MetaTransactionNFT, TrustedForwarder } from "../typechain-types";

export type EIP712Domain = {
  name: string;
  version: string;
  chainId: bigint;
  verifyingContract: string;
};

describe("MetaTransactionNFT and TrustedForwarder", function () {
  let metaTransactionNFT: MetaTransactionNFT;
  let trustedForwarder: TrustedForwarder;
  let functionData: string;
  let domain: EIP712Domain;
  let types: Record<string, any>;
  let user: SignerWithAddress, otherUser: SignerWithAddress;

  before(async function () {
    [user, otherUser] = await ethers.getSigners();

    // Deploy TrustedForwarder contract
    const TrustedForwarderFactory = await ethers.getContractFactory("TrustedForwarder");
    trustedForwarder = await TrustedForwarderFactory.deploy("TrustedForwarder");
    await trustedForwarder.waitForDeployment();

    // Deploy MetaTransactionNFT contract with TrustedForwarder address
    const MetaTransactionNFTFactory = await ethers.getContractFactory("MetaTransactionNFT");
    metaTransactionNFT = await MetaTransactionNFTFactory.deploy(await trustedForwarder.getAddress());
    await metaTransactionNFT.waitForDeployment();

    // Prepare function data for mint
    functionData = metaTransactionNFT.interface.encodeFunctionData("mint");

    // set eip712 domain and types
    const _domain = await trustedForwarder.eip712Domain();
    domain = {
      name: _domain.name,
      version: _domain.version,
      chainId: _domain.chainId,
      verifyingContract: _domain.verifyingContract,
    };
    types = {
      ForwardRequest: [
        { name: "from", type: "address" },
        { name: "to", type: "address" },
        { name: "value", type: "uint256" },
        { name: "gas", type: "uint256" },
        { name: "nonce", type: "uint256" },
        { name: "deadline", type: "uint48" },
        { name: "data", type: "bytes" },
      ],
    };
  });

  it("Should mint NFT correctly", async function () {
    // Mint an NFT as `user`
    await metaTransactionNFT.connect(user).mint();

    // Check the NFT ownership
    const owner = await metaTransactionNFT.ownerOf(0);
    expect(owner).to.equal(user.address);
  });

  it("Should handle meta-transactions correctly", async function () {
    // Sign the meta-transaction
    const request = {
      from: await user.getAddress(),
      to: await metaTransactionNFT.getAddress(),
      value: 0,
      gas: 100000,
      nonce: await trustedForwarder.nonces(await user.getAddress()),
      deadline: Math.floor(Date.now() / 1000) + 3600, // 1 hour in the future
      data: functionData,
    };

    const signature = await user.signTypedData(domain, types, request);

    const forwardRequest = {
      ...request,
      signature,
    };

    // verify signature
    const verified = await trustedForwarder.verify(forwardRequest);
    expect(verified).to.equal(true);

    // Execute the forward request
    await trustedForwarder.connect(otherUser).execute(forwardRequest);

    // Check the NFT ownership
    const owner = await metaTransactionNFT.ownerOf(1);
    expect(owner).to.equal(await user.getAddress());
  });

  it("Should revert invalid forward request", async function () {
    // Create an invalid forward request
    const request = {
      from: await otherUser.getAddress(),
      to: await metaTransactionNFT.getAddress(),
      value: 0,
      gas: 100000,
      nonce: await trustedForwarder.nonces(await otherUser.getAddress()),
      deadline: Math.floor(Date.now() / 1000) + 3600, // 1 hour in the future
      data: functionData,
    };

    const signature = await user.signTypedData(domain, types, request);

    console.log(`signature: ${signature}`);

    const invalidRequest = {
      ...request,
      signature,
    };

    // verify signature
    const verified = await trustedForwarder.verify(invalidRequest);
    expect(verified).to.equal(false);
  });
});
