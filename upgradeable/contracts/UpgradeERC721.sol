// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import {ERC721Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract UpgradeERC721 is Initializable, ERC721Upgradeable, OwnableUpgradeable {
    string private _baseTokenURI;
    uint256 private _nextTokenId;
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /// @notice 初期化関数
    function initialize(
        string memory name,
        string memory symbol,
        string memory baseTokenURI
    ) public initializer {
        __ERC721_init(name, symbol);
        __Ownable_init(msg.sender);

        _baseTokenURI = baseTokenURI;
    }

    /// @notice トークンをミント
    function mint(address to) external onlyOwner {
        _mint(to, _nextTokenId);
        _nextTokenId++;
    }

    /// @notice ベースURIを設定
    function setBaseTokenURI(string memory baseTokenURI) external onlyOwner {
        _baseTokenURI = baseTokenURI;
    }

    /// @notice トークンURIを取得
    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    /// @notice 新しいロジックを追加できる例
    function burn(uint256 tokenId) external onlyOwner {
        _burn(tokenId);
    }

    function getNextTokenId() external view returns (uint256) {
        return _nextTokenId;
    }
}
