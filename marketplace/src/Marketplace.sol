// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {IMarketplace} from "./IMarketplace.sol";
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {IERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";

contract Marketplace is IMarketplace, Ownable {
    // *********************************************
    //                   STORAGE
    // *********************************************

    uint256 public itemId;

    /// @dev item id => item
    mapping(uint256 => Item) public items;

    // アイテムごとの入札金額を追跡
    /// @dev item id => bidder => bid amount
    mapping(uint256 => mapping(address => uint256)) public bids;

    /// @dev item id => NFT contract address => tokenId

    mapping(uint256 => NFT) public nfts;

    // *********************************************
    //                   MODIFIER
    // *********************************************

    modifier onlyExistItem(uint256 _id) {
        if (_id == 0 || _id > itemId) {
            revert("!ID");
        }
        _;
    }

    modifier onlySale(uint256 _id) {
        if (items[_id].isSold) {
            revert("!SALE");
        }
        _;
    }

    // *********************************************
    //                   CONSTRUCTOR
    // *********************************************

    constructor() Ownable(msg.sender) {}

    // *********************************************
    //                EXTERNAL WRITE
    // *********************************************

    /// @notice NFTを出品する関数
    /// @param _price NFTの価格
    /// @param _isAuction オークションかどうか
    /// @param _auctionStart オークション開始時間
    /// @param _auctionEnd オークション終了時間
    /// @param _nftContract NFTコントラクトアドレス
    /// @param _tokenId NFTのトークンID
    function listNFT(
        uint256 _price,
        bool _isAuction,
        uint256 _auctionStart,
        uint256 _auctionEnd,
        address _nftContract,
        uint256 _tokenId
    ) external {
        if (_price == 0) {
            revert("!PRICE");
        }

        IERC721 nft = IERC721(_nftContract);

        // 出品者がNFTの所有者であることを確認
        if (nft.ownerOf(_tokenId) != msg.sender) {
            revert("!OWNER");
        }

        // NFTをマーケットプレイスコントラクトに転送
        nft.transferFrom(msg.sender, address(this), _tokenId);

        itemId++;
        items[itemId] = Item({
            seller: msg.sender,
            buyer: address(0),
            price: _price,
            isSold: false,
            isAuction: _isAuction,
            auctionStart: _auctionStart,
            auctionEndTime: _auctionEnd,
            highestBidder: address(0),
            highestBid: 0
        });

        nfts[itemId] = NFT({
            nftContract: _nftContract,
            tokenId: _tokenId
        });

        emit ItemListed(
            itemId,
            msg.sender,
            _price,
            _isAuction,
            _auctionStart,
            _auctionEnd
        );
    }

    /// @notice NFTを購入する関数（オークション以外の場合）
    /// @param _id アイテムのID
    function buyNFT(
        uint256 _id
    ) external payable onlyExistItem(_id) onlySale(_id) {
        Item storage item = items[_id];
        NFT storage nft = nfts[_id];

        if (item.isAuction) {
            revert("!AUCTION");
        }

        if (msg.value != item.price) {
            revert("!PRICE");
        }

        item.buyer = msg.sender;
        item.isSold = true;

        // 売り上げを出品者に送金
        payable(item.seller).transfer(msg.value);

        // NFTを購入者に転送
        IERC721(nft.nftContract).transferFrom(address(this), msg.sender, nft.tokenId);

        emit ItemBought(_id, msg.sender, item.price);
    }

    /// @notice 入札を行う関数
    /// @param _id アイテムのID
    function bid(
        uint256 _id
    ) external payable onlyExistItem(_id) {
        Item storage item = items[_id];

        if (!isAuction(_id)) {
            revert("!AUCTION");
        }

        if (msg.value <= item.highestBid) {
            revert("!BID");
        }

        // 既存の入札金額を返金
        if (item.highestBid > 0) {
            payable(item.highestBidder).transfer(item.highestBid);
        }

        // 新しい入札を記録
        item.highestBid = msg.value;
        item.highestBidder = msg.sender;
        bids[_id][msg.sender] += msg.value;

        emit NewBid(_id, msg.sender, msg.value);
    }

    /// @notice オークション終了後にNFTを落札者に移転する関数
    /// @param _id アイテムのID
    function endAuction(
        uint256 _id
    ) external onlyExistItem(_id) onlySale(_id) {
        Item storage item = items[_id];
        NFT storage nft = nfts[_id];

        if (isAuction(_id)) {
            revert("!AUCTION");
        }

        item.isSold = true;
        if (item.highestBid > 0) {
            item.buyer = item.highestBidder;

            // 売り上げを出品者に送金
            payable(item.seller).transfer(item.highestBid);

            // NFTを落札者に転送
            IERC721(nft.nftContract).transferFrom(address(this), item.highestBidder, nft.tokenId);

            emit AuctionEnded(_id, item.highestBidder, item.highestBid);
        }
    }

    // *********************************************
    //                EXTERNAL VIEW
    // *********************************************

    /// @notice オークションが有効かどうかを確認する関数
    /// @param _id アイテムのID
    /// @return オークションが有効かどうか
    function isAuction(uint256 _id) public view returns (bool) {
        if (
            !items[_id].isAuction ||
            items[_id].auctionEndTime < block.timestamp ||
            block.timestamp < items[_id].auctionStart
        ) {
            return false;
        }
        return true;
    }
}
