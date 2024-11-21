// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

interface IMarketplace {
    // *********************************************
    //                   ERROR
    // *********************************************

    error PriceIsZero();
    error ItemNotExist();
    error AuctionItem();
    error IncorrectPrice();
    error NotAuctionTime();
    error ItemAlreadySold();
    error OnlySeller();
    error OnlyBuyer();
    error AuctionAlreadyStarted();
    error BidTooLow();

    // *********************************************
    //                   EVENT
    // *********************************************

    event ItemListed(
        uint256 indexed id,
        address indexed seller,
        uint256 price,
        bool isAuction,
        uint256 auctionStart,
        uint256 auctionEndTime
    );
    event ItemBought(uint256 indexed id, address indexed buyer, uint256 price);
    event AuctionStarted(uint256 indexed id, uint256 auctionEndTime);
    event NewBid(uint256 indexed id, address indexed bidder, uint256 bidAmount);
    event AuctionEnded(uint256 indexed id, address winner, uint256 winningBid);

    // *********************************************
    //                   STRUCT
    // *********************************************

    struct Item {
        address seller;
        address buyer;
        uint256 price;
        bool isSold;
        bool isAuction;
        uint256 auctionStart;
        uint256 auctionEndTime;
        address highestBidder;
        uint256 highestBid;
    }

    struct NFT {
        address nftContract;
        uint256 tokenId;
    }
}
