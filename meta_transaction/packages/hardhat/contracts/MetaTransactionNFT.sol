// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { ERC2771Context } from "@openzeppelin/contracts/metatx/ERC2771Context.sol";
import { Context } from "@openzeppelin/contracts/utils/Context.sol";

contract MetaTransactionNFT is ERC721, ERC2771Context {
	uint256 private _currentTokenId;

	constructor(address trustedForwarder)
		ERC721("MetaTransactionNFT", "MTNFT")
		ERC2771Context(trustedForwarder)
	{}

	function mint() external {
		uint256 newTokenId = _currentTokenId++;
		_mint(_msgSender(), newTokenId);
	}

	// Override ERC2771Context
	function _msgSender()
		internal
		view
		override(Context, ERC2771Context)
		returns (address sender)
	{
		return ERC2771Context._msgSender();
	}

	function _msgData()
		internal
		view
		override(Context, ERC2771Context)
		returns (bytes calldata)
	{
		return ERC2771Context._msgData();
	}

	function _contextSuffixLength()
		internal
		view
		override(Context, ERC2771Context)
		returns (uint256)
	{
		return ERC2771Context._contextSuffixLength();
	}
}
