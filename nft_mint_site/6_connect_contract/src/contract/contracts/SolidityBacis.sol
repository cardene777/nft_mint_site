// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {ISolidityBasic} from "./ISolidityBasic.sol";

contract SolidityBasic is ERC721, AccessControl, ISolidityBasic {
    uint256 public supply;
    string public description;
    address public owner;
    bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
    uint128 public constant MAX_SUPPLY = 10000;
    uint64 public constant mintPrice = 0.01 ether;
    uint32 public launchTimestamp;
    uint16 public rewardRate;
    uint8 private _version;
    bool public isDiscount;

    modifier onlyOperator() {
        require(hasRole(OPERATOR_ROLE, msg.sender), "Not operator");
        _;
    }

    constructor(
        string memory _description,
        uint32 _launchTimestamp,
        uint16 _rewardRate,
        uint8 version,
        bool _isDiscount
    ) ERC721("SolidityBasic", "SB") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        description = _description;
        launchTimestamp = _launchTimestamp;
        rewardRate = _rewardRate;
        _version = version;
        isDiscount = _isDiscount;
    }

    function mint(
        uint256 amount
    ) public payable onlyOperator returns (uint256[] memory tokenIds) {
        require(block.timestamp >= launchTimestamp, "Not launched yet");
        if (supply + amount > MAX_SUPPLY) revert MaxSupplyReached();
        uint64 price = calculateMintPrice();
        if (msg.value < price * amount) revert InsufficientFunds();

        tokenIds = new uint256[](amount);
        for (uint256 i = 0; i < amount; i++) {
            _mint(msg.sender, supply + 1);
            tokenIds[i] = supply + 1;
            supply++;
        }
    }

    function calculateMintPrice() public view returns (uint64) {
        return isDiscount ? mintPrice / 2 : mintPrice;
    }

    function bulkBurn(uint256[] memory tokenIds) public {
        uint256 length = tokenIds.length;
        while (length > 0) {
            _burn(tokenIds[length - 1]);
            length--;
        }
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function calculateDecimals(
        uint256 decimals,
        uint256 value1,
        uint256 value2
    ) public pure override returns (uint256) {
        uint256 value = (value1 * (10**decimals)) / value2;
        return value;
    }
}
