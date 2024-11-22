// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {DappsNft} from "../src/NFT.sol";
import {Marketplace} from "../src/Marketplace.sol";

contract DeployMarketplace is Script {
    DappsNft public nft;
    Marketplace public marketplace;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        nft = new DappsNft(msg.sender, msg.sender);
        marketplace = new Marketplace();

        vm.stopBroadcast();
    }
}
