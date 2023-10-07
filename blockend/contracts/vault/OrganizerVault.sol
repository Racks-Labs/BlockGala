// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import { AppStorage } from "blockend/contracts/libraries/AppStorage.sol";
import { Errors } from "blockend/contracts/libraries/Errors.sol";
import { Modifiers } from "blockend/contracts/libraries/Modifiers.sol";
import { ERC4626 } from "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { IDiamondLoupe } from "blockend/contracts/interfaces/IDiamondLoupe.sol";

contract SubscriptorsVault is ERC4626 {
    IDiamondLoupe immutable public blockGalaProxy;

    mapping(address => uint256) public shareHolder;
    /**
     * @dev We can also launch a token convertible to the affiliation program
     */
    constructor(address _asset, address _blockGalaProxy) ERC4626(IERC20(_asset)) {
        blockGalaProxy = IDiamondLoupe(_blockGalaProxy);
    }

    function deposit(uint256, address) override public returns (uint256 shares) {
        uint256 assets = blockGalaProxy.getAmountOfSubscriptionsBoughtCost(msg.sender);
        
        shares = super.deposit(assets, msg.sender);
    }

}