// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import { AppStorage } from "../libraries/AppStorage.sol";
import { Errors } from "../libraries/Errors.sol";
import { Modifiers } from "../libraries/Modifiers.sol";
import { ERC4626 } from "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

interface IViewFacet {
    function getAmountOfSubscriptionsBoughtCost(address _blockGalaUser) external view returns (uint256 amount);
}

contract SubscriptorsVault is ERC4626 {
    IViewFacet public blockGalaProxy;
    bool muttex;

    mapping(address => uint256) public shareHolder;
    /**
     * @dev We can also launch a token convertible to the affiliation program
     */
    constructor(address _asset) ERC4626(IERC20(_asset)) ERC20("Movistar+ DAO", "M+DAO") {}

    function initialize(IViewFacet _blockGalaProxy) public { // for deploy inheritance logic purposes
        require(!muttex);
        blockGalaProxy = IViewFacet(_blockGalaProxy);
        muttex = true;
    }

    function deposit(uint256, address) override public returns (uint256 shares) {
        uint256 assets = blockGalaProxy.getAmountOfSubscriptionsBoughtCost(msg.sender);
        
        shares = super.deposit(assets, msg.sender);
    }

        function _deposit(address caller, address receiver, uint256 assets, uint256 shares) internal override {
        // remove transferFrom since it's not acception any token, but deposits are by amount of dollars invested in subscriptions
        _mint(receiver, shares);

        emit Deposit(caller, receiver, assets, shares);
    }

}