// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

interface ISolidityBasic {
    error MaxSupplyReached();
    error InsufficientFunds();

    event Mint(address indexed operator, address indexed to, uint256[]);

    struct MintedItem {
        uint256 amount;
    }

    function mint(
        uint256 amount
    ) external payable returns (uint256[] memory tokenIds);

    function calculateDecimals(
        uint256 decimals,
        uint256 value1,
        uint256 value2
    ) external pure returns (uint256);
}
