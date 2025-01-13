# NFT Marketplace

ハンズオンの2つ目として、Marketplaceコントラクトを作成していきます。
このハンズオンではコントラクトだけの作成になります。

コードは、以下のGithub内にあります。
dapps_bookリポジトリの「`marketplace`」ディレクトリ内にまとめています。

https://github.com/cardene777/dapps_book/tree/main/marketplace

## Foundry環境作成

今回はFoundryと呼ばれる開発ツールを使用していきます。
現在（2024年12月）、hardhatと並べられてよく使用されているコントラクト開発ツールです。
hardhatとの大きな違いとしては、コントラクトのテストをsolidityで書くことができる点です。
どちらを使用した方が良いかは完全に好みなので、ぜひハンズオンを通して自分に合った開発ツールを使用してみてください。

では、まずはFoundryをインストールする必要があります。
以下のコマンドを実行するか、公式のドキュメントをもとに好きな方法でFoundryをインストールしてください。
https://book.getfoundry.sh/getting-started/installation

```bash
$ curl -L https://foundry.paradigm.xyz | bash
```

インストールができたら、以下のコマンドを実行してバージョン情報が出力されていればインストールできています。

```bash
$ forge --version
forge 0.2.0 (82ff8ee 2024-07-10T00:22:22.246315000Z)
```

インストールができたので、次に環境を作成していきましょう。
以下のコマンドを実行してください。

```bash
$ mkdir marketplace
$ cd marketplace
$ forge init
```

「marketplace」ディレクトリ内にファイルやディレクトリが作成されていれて、以下のように出力されていればベースの環境の作成は成功です。

```bash
Initializing /…/dapps_book/marketplace...
Installing forge-std in /…/marketplace/lib/forge-std (url: Some("https://github.com/foundry-rs/forge-std"), tag: None)
Cloning into '/…/marketplace/lib/forge-std'...
remote: Enumerating objects: 1935, done.
remote: Counting objects: 100% (1930/1930), done.
remote: Compressing objects: 100% (731/731), done.
remote: Total 1935 (delta 1288), reused 1743 (delta 1152), pack-reused 5 (from 1)
Receiving objects: 100% (1935/1935), 631.49 KiB | 8.20 MiB/s, done.
Resolving deltas: 100% (1288/1288), done.
    Installed forge-std v1.9.4
    Initialized forge project
```


srcディレクトリ内に「Counter.sol」というファイルがあるので、以下のコマンドを実行して削除してください。

```bash
$ rm src/Counter.sol 
```

testディレクトリ内に「Counter.t.sol」というファイルがあるので、以下のコマンドを実行してこちらも削除してください。

```bash
$ rm test/Counter.t.sol
```

scriptディレクトリ内に「Counter.s.sol」というファイルがあるので、以下のコマンドを実行してこちらも削除してください。

```bash
$ rm script/Counter.s.sol
```


これで、Foundry環境を構築して、コントラクトを作成する準備は完了です。

## ライブラリのインストール

次にFoundryでのライブラリのインストール方法を確認していきます。
Foundryでは、「forge install」というコマンドでライブラリをインストールすることができます。
以下のコマンドを実行してインストールしてください。

```bash
$ forge install OpenZeppelin/openzeppelin-contracts
```

この時、もし以下のようなエラーが出たら、インストールコマンドの末尾に「--no-commit」とつけてください。

```bash
The target directory is a part of or on its own an already initialized git repository,
and it requires clean working and staging areas, including no untracked files.

Check the current git repository's status with `git status`.
Then, you can track files with `git add ...` and then commit them with `git commit`,
ignore them in the `.gitignore` file, or run this command again with the `--no-commit` flag.

If none of the previous steps worked, please open an issue at:
https://github.com/foundry-rs/foundry/issues/new/choose
```

例）

```bash
$ forge install OpenZeppelin/openzeppelin-contracts --no-commit
```

コマンドの実行が成功すると、「src/lib」ディレクトリ内に「openzeppelin-contracts」というディレクトリが追加されているのが確認できます。
「src/lib」ディレクトリには他に「forge-std」というライブラリがインストールされています。
このライブラリはFoundryでの開発に必要な機能が色々と実装されているものになります。

ライブラリのインストールは完了しましたが、このままではSolidityファイルでインポートする時に以下のようにぱっと見ではどのライブラリを使用しているかわかりづらくなってしまいます。

```solidity
import { Ownable } from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
```

そこで、エイリアスを定義してよりどのライブラリかわかりやすくしたいと思います。
エイリアスを定義するには、インストールしたSolidityファイルのインポートパスを管理する、「remappings.txt」というファイルを作成する必要があります。
以下のコマンドで「remappings.txt」を作成してください。

```bash
$ touch remappings.txt
```

ファイルの作成ができたら、以下を「remappings.txt」ファイル内に貼り付けてください。

```solidity
@openzeppelin/contracts/=lib/openzeppelin-contracts/contracts/
```

これは「`lib/openzeppelin-contracts/contracts/`」にあるSolidityファイルを呼び出す時に、「@openzeppelin/contracts/」という別名で呼び出すことができるようにする定義です。

これでライブラリのインストールは完了です。
Foundryではライブラリをインストールするとき、インストールとエイリアスの定義をセットで行うと管理がしやすくなるのでおすすめです。

## コントラクト作成

Foundry環境の構築ができたので、次にコントラクトを作成していきます。

### NFTコントラクトの作成

まずは、Markeplaceに出品するためのNFTコントラクトを作成していきます。
１つ前のハンズオンで作成したNFTコントラクトを使用していきます。
以下のコマンドを実行して、srcディレクトリ内に「NFT.sol」というファイルを作成してください。

```bash
$ touch NFT.sol
```

ファイルの作成ができたら以下のコードをファイル内に記述してください。

```solidity
// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

contract DAppsNft is
    ERC721,
    ERC721URIStorage,
    ERC721Pausable,
    AccessControl,
    ERC721Burnable
{
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    uint256 private _nextTokenId;

    constructor(
        address defaultAdmin,
        address pauser
    ) ERC721("DAppsNft", "DNFT") {
        _grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);
        _grantRole(PAUSER_ROLE, pauser);
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function safeMint(address to, string memory uri) public {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    // The following functions are overrides required by Solidity.

    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal override(ERC721, ERC721Pausable) returns (address) {
        return super._update(to, tokenId, auth);
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override(ERC721, IERC721) {
        super.transferFrom(from, to, tokenId);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(ERC721, ERC721URIStorage, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
```

### IMarketplaceインターフェースの作成

次に、Marketplaceコントラクトのinterface用のファイルを作成していきます。
以下のコマンドを実行して、srcディレクトリ内に「IMarketplace.sol」というファイルを作成してください。

```bash
$ touch IMarketplace.sol
```

ファイルの作成ができたら以下のコードをファイル内に記述してください。

```solidity
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
        uint256 id;
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
}
```

### Marketplaceコントラクトの作成

次にコントラクトのファイルを作成していきます。
以下のコマンドを実行して、srcディレクトリ内に「`Marketplace.sol`」というファイルを作成してください。

```bash
$ touch src/Marketplace.sol
```

ファイルの作成ができたら以下のコードをファイル内に記述してください。

```solidity
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
            id: itemId,
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
```

コントラクトの作成ができたので、変数や関数について簡単に説明していきます。
まずは変数と配列から説明していきます。

| 変数/配列 | 説明 |
| ------- | --- |
| `itemId` | MarkeplaceでNFTをリスト（出品）しているItemのID。|
| `items` | リスト（出品）情報を管理しているmapping配列。itemIdをキーにして以下の情報が管理されています。|
| `seller` | NFTをリスト（出品）したアドレス。|
| `buyer` | NFTを購入したアドレス。|
| `price` | NFTの販売価格。|
| `isSold` | 販売済みかどうか。|
| `isAuction` | オークション販売かどうか。|
| `auctionStart` | オークションの開始時間。|
| `auctionEndTime` | オークションの終了時間。|
| `highestBidder` | オークション時に一番最大額で入札したアドレス。|
| `highestBid` | オークションでの最高入札額。|
| `bids` | 入札情報を管理しているmapping配列。itemIdと入札アドレスをキーにして入札額を管理しています。|
| `nfts` | リスト（出品）されているNFTのコントラクト情報を管理しているmapping配列。`itemId`をキーにしてNFTコントラクトのアドレスが管理されています。|

次にmodifierを説明していきます。

onlyExistItem
特定のitemIdがItemとして登録されているか確認し、もし登録されていない場合は「!ID」というエラーを返します。
onlySale
特定のitemIdがまだ販売中かを確認し、もし売却されていた場合は「!SALE」というエラーを返します。

次にconstructorを説明していきます。
constructorはコントラクトのデプロイ時に一度だけ実行される関数で、今回は「Ownable」というコントラクト内のconstructorを実行しています。
「Ownable」は、ownerに設定したアドレスのみが関数を実行できるようにmodifierが定義してあるコントラクトです。
これにより、例えばプロジェクトの運営アドレスからのみ特定の関数を実行するなどの実装ができます。
このコントラクトでは特に使用していないので、ぜひMarketplaceコントラクトを拡張して使用してみてください。

次に関数の説明をしていきます。

listNFT
NFTをリスト（出品）する関数です。
引数でNFTのリスト（出品）に必要な情報を受け取り、データをItem構造体に格納しています。
この時、以下のチェックをしています。
販売額が0でないか。
関数の実行アドレスが出品するNFTを保有しているか。
buyNFT
NFTを購入する関数。
以下のチェックを行い、問題がなければ売り上げを出品者に渡してからNFTを購入者に送付します。
登録されているitem idか。
販売中か。
オークションのアイテムではないか。
送付してきたETHが販売額と同額か。
bid
オークションのアイテムに入札を行う関数。
以下のチェックを行い、問題がなければ入札を行う。
登録されているitem idか。
オークション中のアイテムか。
最高入札額より高い入札か。
endAuction
オークション終了後に落札者にNFTを送付する関数。
以下のチェックを行い、問題がなければ売り上げを出品者に渡してからNFTを落札者に送付します。
登録されているitem idか。
既に落札者に送付されていないか？
オークション中のアイテムではないか。
isAuction
特定のitem idがオークション中かを返す関数。

一通りMarketplaceコントラクトの説明はしたので、こんとらくとと照らし合わせながらより理解度を深めてください。

⚪︎コントラクトのテスト

コントラクトが作成できたので、次にコントラクトのテストを実行していきます。
Foundryでは、テストコードをSolidityで記述することができます。
以下のコマンドを実行して、「Marketplace.t.sol」というテストファイルを作成してください。

```
$ touch test/Marketplace.t.sol
```

テストファイルの作成ができたら、以下のコードを記述してください。

```

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "forge-std/Test.sol";
import {Marketplace} from "../src/Marketplace.sol";
import {IMarketplace} from "../src/IMarketplace.sol";
import {DAppsNft} from "../src/NFT.sol";

contract MarketplaceTest is Test {
    Marketplace marketplace;
    DAppsNft nft;
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
        nft = new DAppsNft(seller, seller);

        // sellerがNFTを発行
        vm.prank(seller);
        nft.safeMint(seller, "ipfs://test-uri");

        nftTokenId = 0; // 発行されたNFTのtokenId

        vm.label(address(marketplace), "Marketplace");
        vm.label(address(nft), "DAppsNft");
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
```

各関数について成功パターンと失敗パターンのテストコードを書いています。
失敗パターンでは、関数内のエラーがちゃんと動作しているか確認しています。
では以下のコマンドを実行してテストを走らせていきます。

```
$ forge test
```

以下のように出力されていればテスト実行成功です。

```
[⠊] Compiling...
[⠔] Compiling 1 files with Solc 0.8.27
[⠒] Solc 0.8.27 finished in 1.44s
Compiler run successful!

Ran 5 tests for test/Marketplace.t.sol:MarketplaceTest
[PASS] testAuctionFail() (gas: 234831)
[PASS] testAuctionFlow() (gas: 410367)
[PASS] testBuyNFT() (gas: 248882)
[PASS] testBuyNFTFail() (gas: 265549)
[PASS] testListNFT() (gas: 178610)
Suite result: ok. 5 passed; 0 failed; 0 skipped; finished in 3.26ms (2.09ms CPU time)

Ran 1 test suite in 166.42ms (3.26ms CPU time): 5 tests passed, 0 failed, 0 skipped (5 total tests)
```

⚪︎コントラクトのデプロイ（ローカルノード）

コントラクトのテストができたので、次にコントラクトのデプロイをしていきます。
最初はノードを自分のPC内で起動させて、ローカルノードにデプロイしていきます。
まずはデプロイのためのスクリプトファイルを作成していきます。
以下のコマンドを実行してください。

```
$ touch script/Marketplace.s.sol
```

ファイルが作成できたら以下のコードを書いてください。

```
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {DAppsNft} from "../src/NFT.sol";
import {Marketplace} from "../src/Marketplace.sol";

contract DeployMarketplace is Script {
    DAppsNft public nft;
    Marketplace public marketplace;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        nft = new DAppsNft(msg.sender, msg.sender);
        marketplace = new Marketplace();

        vm.stopBroadcast();
    }
}
```

このデプロイスクリプトでは、「DAppsNft」コントラクトと「Marketplace」コントラクトのデプロイを行なっています。
次に、以下のコマンドを実行して環境変数ファイルである「.env」を作成していきます。

```
$ touch .env
```

「.env」ファイルを作成できたら、以下のコードを書いてください。

```
RPC_URL=127.0.0.1:8545
PRIVATE_KEY=
```

これでローカルノードへのデプロイの準備が整いました。
以下のコマンドを実行して、ローカルノードを起動してください。

```
$ anvil
```

以下のように出力されていればローカルノードの起動成功です。

```


                             _   _
                            (_) | |
      __ _   _ __   __   __  _  | |
     / _` | | '_ \  \ \ / / | | | |
    | (_| | | | | |  \ V /  | | | |
     \__,_| |_| |_|   \_/   |_| |_|

    0.2.0 (82ff8ee 2024-07-10T00:22:23.176599000Z)
    https://github.com/foundry-rs/foundry

Available Accounts
`````````===
```

「Available Accounts」はローカルノードで使用できるアドレスの一覧で、「Private Keys」は各アドレスに対応する秘密鍵の一覧です。
「.env」ファイルを開いて、「PRIVATE_KEY」の部分に「Private Keys」の「(0)」の部分の秘密鍵を貼り付けてください。

```
RPC_URL=127.0.0.1:8545
PRIVATE_KEY=0x…
```

次にTerminalde別タブを開いて、「marketplace」ディレクトリまで移動してください。
移動ができたら以下のデプロイコマンドを実行してください。

```
$ source .env
$ forge script script/Marketplace.s.sol --broadcast --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

以下のように出力されていれば、ローカルノードへのデプロイは成功です。

```
## Setting up 1 EVM.

```````````````=

Chain 31337

Estimated gas price: 1.765377551 gwei

Estimated total gas used for script: 3141971

Estimated amount required: 0.005546765069293021 ETH

```````````````=

##### anvil-hardhat
✅  [Success]Hash: 0x1e0fd9f5cf162240095009f942cbb3c0179abf388ce7478a058e403e9b7dad8d
Contract Address: 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
Block: 2
Paid: 0.001319572054926096 ETH (1494946 gas * 0.882688776 gwei)


##### anvil-hardhat
✅  [Success]Hash: 0x579b5549c5280ca7259a2347918fe40956a4ca40297a9d2e9cc0afd90e9c6e05
Contract Address: 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0
Block: 3
Paid: 0.000722759409156789 ETH (922653 gas * 0.783349113 gwei)

✅ Sequence #1 on anvil-hardhat | Total Paid: 0.002042331464082885 ETH (2417599 gas * avg 0.833018944 gwei)
                                                                                                              

```````````````=

ONCHAIN EXECUTION COMPLETE & SUCCESSFUL.
```

ローカルノードが起動しているTerminalのタブを確認して、以下のように出力されているかも確認しましょう。

```
    Transaction: 0x1e0fd9f5cf162240095009f942cbb3c0179abf388ce7478a058e403e9b7dad8d
    Contract created: 0xe7f1725e7734ce288f8367e1bb143e90bb3f0512
    Gas used: 1494946

    Block Number: 1
    Block Hash: 0x89b8f8f09e611484a0c9e02bf52b12a87601e252489f6b2898833a5fa6624dd0
    Block Time: "Thu, 21 Nov 2024 15:46:43 +0000"


    Transaction: 0x579b5549c5280ca7259a2347918fe40956a4ca40297a9d2e9cc0afd90e9c6e05
    Contract created: 0x9fe46736679d2d9a65f0992f2272de9f3c7fa6e0
    Gas used: 922653

    Block Number: 2
    Block Hash: 0xfd4234cbc9cc4f37826fb96a5c5d0c1fec9163d17b027cdffef1b6d33ecfa6b2
    Block Time: "Thu, 21 Nov 2024 15:46:44 +0000"
```

「Block Hash」や「Contract created」がデプロイ時の出力と一致していればデプロイの確認も問題ないです。
出力されているコントラクトアドレスは後で使用するため、どこかにメモしておいてください。
上のアドレス（この出力の場合「0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512」）がNFTコントラクトのアドレスになります。
下のアドレス（この出力の場合「0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0」）がMarketplaceコントラクトのアドレスになります。

＊確認するときは「anvil」コマンドを実行したTerminalタブで確認してください。
デプロイコマンドを実行したタブでは順序が逆で表示されることがあります。

⚪︎コントラクトの実行（ローカルノード）

ローカルノードへのデプロイができたので、実際にコントラクトの関数を実行していきましょう。

★mint実行

まずは、デプロイコマンドを実行したTerminalタブを開いて、以下のコマンドを実行してNFTをmintしていきます。

```
$ cast send <NFT_CONTRACT_ADDRESS> "safeMint(address,string)" <TO_ADDRESS> <TOKEN_URI> --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

以下の項目に関しては手動で値を設定してください。

CONTRACT_ADDRESS
デプロイしたNFTコントラクトのアドレス。
TO_ADDRESS
Mint先のアドレス。
「anvil」コマンド実行時に出力された「Available Accounts」の「(0)」のアドレスを使用してください。
TOKEN_URI
「https://example.com」など適当な値で良いです。

例）

```
$ cast send 0x5fbdb2315678afecb367f032d93f642f64180aa3 "safeMint(address,string)" "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" "https://example.com" --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

実行に成功するとトランザクション実行情報が出力されます。
以下のように「status」が「success」になっていれば実行成功です。

```
…
status                  1 (success)
…
```

★NFTの保有確認

次に、本当にMintが成功しているか確認するために、「balanceOf」関数と「ownerOf」関数を実行していきます。
まずは、以下のコマンドを実行して「balanceOf」関数からみていきます。

```
$ cast call <NFT_CONTRACT_ADDRESS>  "balanceOf(address)" <ADDRESS> --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

「ADDRESS」部分には、mint時に指定した「TO_ADDRESS」と同じアドレスを入力してください。


例）

```
$ cast call 0x5fbdb2315678afecb367f032d93f642f64180aa3 "balanceOf(address)" "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

以下のように、16進数で「1」と出力されていれば実行成功です。
1つのNFTがmintされていることが確認できました。

```
0x0000000000000000000000000000000000000000000000000000000000000001
```

次に、以下のコマンドを実行して「ownerOf」関数をみていきます。

```
$ cast call <NFT_CONTRACT_ADDRESS> "ownerOf(uint256)" <TOKEN_ID> --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

「TOKEN_ID」部分には、mintしたNFTの「tokenId」である「0」を入力してください。

例）

```
$ cast call 0x5fbdb2315678afecb367f032d93f642f64180aa3 "ownerOf(uint256)" 0 --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

以下のように、mint実行時の「TO_ADDRESS」と同じアドレスが出力されていれば実行成功です。

```
0x00000000000000000000000070997970c51812dc3a010c7d01b50e0d17dc79c8
```=

★setApprovalForAll実行

次にMarketplaceコントラクトにNFTをリスト（出品）するために、「setApprovalForAll」関数を実行していきます。
「setApprovalForAll」関数を実行すると、自信が保有している全てのNFTの操作権限をMarketplaceコントラクトに付与することができます。
また、DAppsではNFTをリスト（出品）するためにこの処理が実行されるようになっていることがほとんどです。
では、以下のコマンドを実行してください。

```
$ cast send <NFT_CONTRACT_ADDRESS> "setApprovalForAll(address,bool)" <OPERATOR_ADDRESS> true --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

「OPERATOR_ADDRESS」には、Marketplaceコントラクトのアドレスを入力してください。

例）

```
$ cast send 0x5fbdb2315678afecb367f032d93f642f64180aa3 "setApprovalForAll(address,bool)" "0xe7f1725e7734ce288f8367e1bb143e90bb3f0512" true --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

実行トランザクションの情報が出力されるので、以下のように「status」部分が「success」になっていれば実行成功です。

```
…
status                  1 (success)
…
```


次に、Marketplaceコントラクトに操作権限が正常に付与されたか確認してきます。
以下のコマンドを実行してください。

```
$ cast call <NFT_CONTRACT_ADDRESS> "isApprovedForAll(address,address)" <OWNER_ADDRESS> <OPERATOR_ADDRESS> --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

「OWNER_ADDRESS」には、mint時に指定した「TO_ADDRESS」と同じアドレスを入力してください。
「OPERATOR_ADDRESS」にはMarketplaceコントラクトアドレスを入力してください。

例）

```
$ cast call 0x5fbdb2315678afecb367f032d93f642f64180aa3 "isApprovedForAll(address,address)" "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" "0xe7f1725e7734ce288f8367e1bb143e90bb3f0512" --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

以下のように出力されていれば、「true」ということなので操作権限が正常に付与されています。

```
0x0000000000000000000000000000000000000000000000000000000000000001
```

★NFTのリスト（出品）

次にNFTをリスト（出品）していきます。
少し長いですが、以下のコマンドを実行してください。

```
$ cast send <MARKETPLACE_CONTRACT_ADDRESS> "listNFT(uint256,bool,uint256,uint256,address,uint256)" <PRICE> <IS_AUCTION> <AUCTION_START> <AUCTION_END> <NFT_CONTRACT_ADDRESS> <TOKEN_ID> --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

それぞれ入力が必要な値について簡単に説明します。

MARKETPLACE_CONTRACT_ADDRESS
Marketplaceコントラクトのアドレス。
PRICE
 設定したいNFTの価格。
wei単位で入力してください。
1 ETH = 1000000000000000000 wei
IS_AUCTION
オークションかどうかのbool値。
AUCTION_START
オークション開始時刻のタイムスタンプ。
AUCTION_END
オークション終了時刻のタイムスタンプ。
NFT_CONTRACT_ADDRESS
NFTコントラクトのアドレス。
TOKEN_ID
リスト（出品）するNFTのtokenId。

例）

```
$ cast send 0xe7f1725e7734ce288f8367e1bb143e90bb3f0512 "listNFT(uint256,bool,uint256,uint256,address,uint256)" 1000000000000000000 false 0 0 0x5fbdb2315678afecb367f032d93f642f64180aa3 0 --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

トランザクション情報が出力されるので、以下のように「status」が「sucess」となっていれば実行成功です。

```
…
status                  1 (success)
…
```

ではしっかり指定した値で出力されているか確認していきます。
「items」mapping配列を確認するために、以下のコマンドを実行してください。

```
$ cast call <MARKETPLACE_CONTRACT_ADDRESS> "items(uint256)" <ITEM_ID> --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

「ITEM_ID」には、初めてリスト（出品）した場合は「1」を渡してください。

例）

```
$ cast call 0xe7f1725e7734ce288f8367e1bb143e90bb3f0512 "items(uint256)" 1 --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

出力は以下のようになっているはずです。

```
0x000000000000000000000000f39fd6e51aad88f6f4ce6ab8827279cfffb9226600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000de0b6b3a7640000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
```

やたら0が多くて読みにくいですが、ちゃんとデータが追加されています。
「items」mapping配列は「Item」構造体を返すため、このようにデータがまとめられてしまっています。
コントラクトのストレージは32Byteごとにデータが格納されているので、分解すると以下のようになります。

0x000000000000000000000000f39fd6e51aad88f6f4ce6ab8827279cfffb92266
リスト（出品）したアドレスで、「f39fd6e51aad88f6f4ce6ab8827279cfffb92266」の部分。
「Available Accounts」の一番上のアドレスが表示されているはずです。
0x0000000000000000000000000000000000000000000000000000000000000000
購入者のアドレスで、デフォルトでは0アドレスです。
0x0000000000000000000000000000000000000000000000000de0b6b3a7640000
設定したNFTの価格です。
「1000000000000000000 wei = 1 ETH」という値を渡したので、16進数に変換されて保存されています。
「1000000000000000000」を16進数に変換すると「de0b6b3a7640000」と一致します。
0x0000000000000000000000000000000000000000000000000000000000000000
売却済みかというbool値で、デフォルトではfalse（0）です。
0x0000000000000000000000000000000000000000000000000000000000000000
オークションかどうかという値で、false（0）と指定しました。
0x0000000000000000000000000000000000000000000000000000000000000000
オークションの開始時刻で「0」を渡しました。
0x0000000000000000000000000000000000000000000000000000000000000000
オークションの終了時刻で「0」を渡しました。
0x0000000000000000000000000000000000000000000000000000000000000000
オークションの最高入札者のアドレスで、デフォルトは0アドレスです。
0x0000000000000000000000000000000000000000000000000000000000000000
オークションの最高入札額で、デフォルトは「0」です。

これでNFTのリスト（出品）はできました。

★NFTの購入

NFTのリスト（出品）ができたので、次に購入をしていきます。
まずは設定している実行アドレスを変更する必要があります。
「.env」ファイルを開いて、「PRIVATE_KEY」に設定している値を「Private Keys」の上から２つ目の値に変更してください。
これで実行アドレスを変更することができ、リスト（出品）したアドレスとは別のアドレスが購入できるようになります。
変更を反映させるために以下のコマンドを実行してください。

```
$ source .env
```

以下のコマンドを実行してください。

```
$ cast send <MARKETPLACE_CONTRACT_ADDRESS> "buyNFT(uint256)" <ITEM_ID> --value <PRICE> --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

「PRICE」にはリスト（出品）された価格である「1000000000000000000 wei = 1 ETH」の値を入力してください。

例）

```
$ cast send 0xe7f1725e7734ce288f8367e1bb143e90bb3f0512 "buyNFT(uint256)" 1 --value 1000000000000000000 --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

トランザクション情報が出力されるので、以下のように「status」が「sucess」となっていれば実行成功です。

```
…
status                  1 (success)
…
```

では、「Item」情報が更新されているかを確認してみます。
先ほど「items」mapping配列を実行したコマンドを再度実行してください。

```
$ cast call <MARKETPLACE_CONTRACT_ADDRESS> "items(uint256)" <ITEM_ID> --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

例）

```
$ cast call 0xe7f1725e7734ce288f8367e1bb143e90bb3f0512 "items(uint256)" 1 --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

実行が成功すると以下のように出力されて、先ほどとは出力内容が異なることがわかります。

```
0x000000000000000000000000f39fd6e51aad88f6f4ce6ab8827279cfffb9226600000000000000000000000070997970c51812dc3a010c7d01b50e0d17dc79c80000000000000000000000000000000000000000000000000de0b6b3a7640000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
```=

更新箇所は以下になります。

0x00000000000000000000000070997970c51812dc3a010c7d01b50e0d17dc79c8
購入者アドレスが表示されています。
購入には別のアドレスを使用しているため、「0x70997970c51812dc3a010c7d01b50e0d17dc79c8」というアドレスが反映されているのが確認できます。
0000000000000000000000000000000000000000000000000000000000000001
NFTが売却されたので、true（1）に変換されています。

これで一通りの処理を、ローカルノードで実行と確認ができました。
実行したコマンドを参考にして、オークション処理の方も試してみてください。
ローカルノードは「Command + C」で終了できます。
⚪︎テストネットにデプロイ

では、最後にテストネットにコントラクトをデプロイしてこの章のハンズオンを終わりにしていきます。

「.env」ファイルを開いて、「RPC_URL」の部分を「https://holesky.drpc.org」に変換してください。
「PRIVATE_KEY」には、１つ前のハンズオンで使用したアドレスか、Holeskyテストネットトークンを保有しているアドレスを設定してください。
変換ができたら、環境変数の変更を反映するために以下のコマンドを実行してください。

```
$ source .env
```

環境変数の反映ができたら、以下のコマンドを実行してHoleskyテストネットにMarketplaceコントラクトをデプロイしていきます。

```
$ forge create --rpc-url $RPC_URL --private-key $PRIVATE_KEY src/Marketplace.sol:Marketplace
```

以下のようにデプロイしたコントラクトアドレスが表示されていれば、デプロイ成功です。

```
Deployer: …
Deployed to: 0xAd6a3f370c872d6601790C52D5A2cDF990b8Fb35
Transaction hash: 0xb323349ba2d523c07851d16dc3cdfda5e84fc9763e69cfdb79423bd7590a076b
```

ちゃんとデプロイされているか、Explorerを開いて確認していきます。
以下の「CONTRACT_ADDRESS」の部分に、デプロイされたコントラクトのアドレスを入力してブラウザで開いてください。

「https://holesky.etherscan.io/address/<CONTRACT_ADDRESS> 」

画像7-55のように「Contract Creation」と表示されていればデプロイ成功です


画像7-55
⚪︎まとめ

このハンズオンでは、Marketplaceコントラクトをfoundryで作成してきました。
このコントラクトは、実際に使用するには以下のように改善点が幾つかあります。
リスト（出品）した情報の更新や削除する機能。
2次流通手数料やMarketplace利用手数料の設定。
煩雑な定義の更新（nfts mapping配列はItem構造体に統合可能）。

そのため、ぜひ自分で足りない要素を実装してみてください。
また、１つ前のハンズオンを参考にしてフロントエンドも作成すると理解が深まると思います。
