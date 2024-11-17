// SPDX-License-Identifier: MIT

pragma solidity 0.8.27;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract SolidityBasic is ERC721, AccessControl {
    uint256 public supply;
    string public description;
    address public owner;
    bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
    uint128 public constant MAX_SUPPLY = 10000;
    uint64 public launchTimestamp;
    uint32 public constant mintPrice = 0.01 ether;
    uint16 public rewardRate;
    uint8 private _version;

    modifier onlyOperator() {
        require(hasRole(OPERATOR_ROLE, msg.sender), "Not operator");
        _;
    }

    constructor(string memory _description, uint64 _launchTimestamp, uint16 _rewardRate, uint8 _version) ERC721("SolidityBasic", "SB") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        description = _description;
        launchTimestamp = _launchTimestamp;
        rewardRate = _rewardRate;
        _version = _version;
    }

    function mint(uint256 amount) public payable onlyOperator {
        require(block.timestamp >= launchTimestamp, "Not launched yet");
        if (supply + amount > MAX_SUPPLY) revert MaxSupplyReached();
        if (msg.value < mintPrice * amount) revert InsufficientFunds();
        for (uint256 i = 0; i < amount; i++) {
            _mint(msg.sender, supply + 1);
            supply++;
        }
    }
}
