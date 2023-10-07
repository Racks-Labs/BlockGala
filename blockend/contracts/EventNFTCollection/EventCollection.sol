// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import { ClonableERC721 } from "../utils/ClonableERC721.sol";

error CallerNotDiamond();

contract EventCollection is ClonableERC721 {
    address public diamondAddress;
    string baseURI;

    modifier onlyDiamond() {
        if (diamondAddress != msg.sender) revert CallerNotDiamond();
        _;
    }

    constructor () {
        diamondAddress = msg.sender;
    }
    /**
     * @dev No need for initializer, super.initialize already has it
     */
    function initializes(string memory _name, string memory _symbol, string memory _description) public {
        super.initialize(_name, _symbol, _description);
    }

    function mint(address to, uint256 quantity) external onlyDiamond {
        _mint(to, quantity);
    }
    // set to onlyDiamond so only transfers, mints and burns can be done by the diamond, managing correlationed data
    function _transfer(address from, address to, uint256 tokenId) internal onlyDiamond override {
        super._transfer(from, to, tokenId);
    }

    function burn(uint256 tokenId) external onlyDiamond {
        _burn(tokenId);
    }

    function changeBaseUri(string memory _newBaseURI) external onlyDiamond {
        baseURI = _newBaseURI;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }
}