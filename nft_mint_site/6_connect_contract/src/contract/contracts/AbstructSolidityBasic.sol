// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

abstract contract AbstractSolidityBasic {
    error MaxSupplyReached();
    error InsufficientFunds();

    function mint(uint256 amount) external payable virtual;

    function calculateDecimals(
        uint256 decimals,
        uint256 value1,
        uint256 value2
    ) public pure returns (uint256) {
        uint256 value = (value1 * (10**decimals)) / value2;
        return value;
    }
}
