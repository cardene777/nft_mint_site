// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract DappsNft is
    ERC721,
    ERC721URIStorage,
    ERC721Pausable,
    AccessControl,
    ERC721Burnable
{
    using Strings for uint256;
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    uint256 private _nextTokenId;
    string private _baseURI;
    string private _extension;

    constructor(
        address defaultAdmin,
        address pauser
    ) ERC721("DappsNft", "DNFT") {
        _grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);
        _grantRole(PAUSER_ROLE, pauser);
        _baseURI = baseURI;
        _extension = extension;
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    // function safeMint(address to, string memory uri) public {
    //     uint256 tokenId = _nextTokenId++;
    //     _safeMint(to, tokenId);
    //     _setTokenURI(tokenId, uri);
    // }
    // function safeMint(address to) public {
    //     uint256 tokenId = _nextTokenId++;
    //     _safeMint(to, tokenId);
    // }
    function safeMint(
        address to,
        string memory name,
        string memory description,
        string memory imageData
    ) public {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);

        // Store metadata on-chain
        _names[tokenId] = name;
        _descriptions[tokenId] = description;
        _imageData[tokenId] = imageData;
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

    // function tokenURI(
    //     uint256 tokenId
    // ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
    //     return super.tokenURI(tokenId);
    // }
    // function tokenURI(
    //     uint256 tokenId
    // ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
    //     return string.concat(_baseURI, tokenId.toString(), _extension);
    // }
    // function tokenURI(
    //     uint256 tokenId
    // ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
    //     return string.concat(_baseURI, "?tokenId=", tokenId.toString());
    // }
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        // Generate on-chain metadata JSON
        string memory json = string.concat(
            '{"name":"',
            _names[tokenId],
            '","description":"',
            _descriptions[tokenId],
            '","image":"data:image/svg+xml;base64,',
            _imageData[tokenId],
            '"}'
        );

        // Return base64-encoded JSON
        return string.concat("data:application/json;base64,", _encodeBase64(bytes(json)));
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
