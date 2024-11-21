// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "forge-std/Test.sol";
import {Marketplace} from "../src/Marketplace.sol";
import {IMarketplace} from "../src/IMarketplace.sol";
import {DappsNft} from "../src/NFT.sol";

contract MarketplaceTest is Test {
    Marketplace marketplace;
    DappsNft nft;
    address seller = makeAddr("seller");
    address buyer = makeAddr("buyer");
    address bidder1 = makeAddr("bidder1");
    address bidder2 = makeAddr("bidder2");

    uint256 nftTokenId;

    function setUp() public {
        vm.deal(seller, 10 ether);
        vm.deal(buyer, 10 ether);
        vm.deal(bidder1, 10 ether);
        vm.deal(bidder2, 10 ether);

        marketplace = new Marketplace();
        nft = new DappsNft(seller, seller);

        // sellerがNFTを発行
        vm.prank(seller);
        nft.safeMint(seller, "ipfs://test-uri");

        nftTokenId = 0; // 発行されたNFTのtokenId

        vm.label(address(marketplace), "Marketplace");
        vm.label(address(nft), "DappsNft");
        vm.label(seller, "Seller");
        vm.label(buyer, "Buyer");
        vm.label(bidder1, "Bidder1");
        vm.label(bidder2, "Bidder2");
    }

    /// @dev NFTの出品テスト（正常系）
    function testListNFT() public {
        vm.startPrank(seller);

        // marketplaceにNFTのtransferを許可
        nft.approve(address(marketplace), nftTokenId);

        vm.expectEmit(address(marketplace));
        emit IMarketplace.ItemListed(1, seller, 1 ether, false, 0, 0);

        marketplace.listNFT(1 ether, false, 0, 0, address(nft), nftTokenId);

        (
            address _seller,
            ,
            uint256 _price,
            bool _isSold,
            bool _isAuction,
            uint256 _auctionStart,
            uint256 _auctionEnd,
            ,

        ) = marketplace.items(1);

        assertEq(_seller, seller);
        assertEq(_price, 1 ether);
        assertEq(_isSold, false);
        assertEq(_isAuction, false);
        assertEq(_auctionStart, 0);
        assertEq(_auctionEnd, 0);

        vm.stopPrank();
    }

    /// @dev NFT購入テスト（正常系）
    function testBuyNFT() public {
        vm.startPrank(seller);

        // marketplaceにNFTのtransferを許可
        nft.approve(address(marketplace), nftTokenId);
        marketplace.listNFT(1 ether, false, 0, 0, address(nft), nftTokenId);

        vm.stopPrank();

        uint256 sellerInitialBalance = seller.balance;

        vm.startPrank(buyer);
        vm.expectEmit(address(marketplace));
        emit IMarketplace.ItemBought(1, buyer, 1 ether);

        marketplace.buyNFT{value: 1 ether}(1);

        (, address _buyer, , bool _isSold, , , , , ) = marketplace.items(1);
        assertEq(_buyer, buyer);
        assertEq(_isSold, true);
        assertEq(seller.balance, sellerInitialBalance + 1 ether);
        assertEq(nft.ownerOf(nftTokenId), buyer);

        vm.stopPrank();
    }

    /// @dev NFT購入時のエラーテスト
    function testBuyNFTFail() public {
        vm.startPrank(seller);

        // marketplaceにNFTのtransferを許可
        nft.approve(address(marketplace), nftTokenId);
        marketplace.listNFT(1 ether, false, 0, 0, address(nft), nftTokenId);

        vm.stopPrank();

        // 無効なアイテムID
        vm.startPrank(buyer);
        vm.expectRevert(bytes("!ID"));
        marketplace.buyNFT{value: 1 ether}(999);

        // 不正な価格
        vm.expectRevert("!PRICE");
        marketplace.buyNFT{value: 0.5 ether}(1);

        // 売り切れアイテム
        marketplace.buyNFT{value: 1 ether}(1);
        vm.expectRevert("!SALE");
        marketplace.buyNFT{value: 1 ether}(1);

        vm.stopPrank();
    }

    /// @dev オークション開始・入札・終了テスト（正常系）
    function testAuctionFlow() public {
        vm.startPrank(seller);

        // marketplaceにNFTのtransferを許可
        nft.approve(address(marketplace), nftTokenId);
        marketplace.listNFT(
            1 ether,
            true,
            block.timestamp + 1,
            block.timestamp + 3600,
            address(nft),
            nftTokenId
        );

        vm.stopPrank();

        // 入札前に失敗
        vm.startPrank(bidder1);
        vm.expectRevert("!AUCTION");
        marketplace.bid{value: 2 ether}(1);
        vm.stopPrank();

        // オークション開始後に入札
        vm.warp(block.timestamp + 1);
        vm.startPrank(bidder1);
        marketplace.bid{value: 2 ether}(1); // 2 ETHで入札
        vm.stopPrank();

        vm.startPrank(bidder2);
        marketplace.bid{value: 3 ether}(1); // 3 ETHで入札
        vm.stopPrank();

        // オークション終了
        vm.warp(block.timestamp + 3601);
        vm.startPrank(seller);

        uint256 sellerInitialBalance = seller.balance;

        vm.expectEmit(address(marketplace));
        emit IMarketplace.AuctionEnded(1, bidder2, 3 ether);
        marketplace.endAuction(1);

        (,address _buyer, , bool _isSold, , , , , ) = marketplace.items(1);
        assertEq(_buyer, bidder2);
        assertEq(_isSold, true);
        assertEq(seller.balance, sellerInitialBalance + 3 ether);
        assertEq(nft.ownerOf(nftTokenId), bidder2);

        vm.stopPrank();
    }

    /// @dev オークション時のエラーテスト
    function testAuctionFail() public {
        vm.startPrank(seller);

        // marketplaceにNFTのtransferを許可
        nft.approve(address(marketplace), nftTokenId);
        marketplace.listNFT(
            1 ether,
            true,
            block.timestamp + 1,
            block.timestamp + 3600,
            address(nft),
            nftTokenId
        );

        vm.stopPrank();

        vm.warp(block.timestamp + 1);

        // 終了時間前にオークション終了
        vm.prank(seller);
        vm.expectRevert("!AUCTION");
        marketplace.endAuction(1);

        // 存在しないアイテム
        vm.expectRevert(bytes("!ID"));
        marketplace.endAuction(999);
    }
}
