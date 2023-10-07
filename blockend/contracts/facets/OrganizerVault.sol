// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import { AppStorage } from "blockend/contracts/libraries/AppStorage.sol";
import { Errors } from "blockend/contracts/libraries/Errors.sol";
import { Modifiers } from "blockend/contracts/libraries/Modifiers.sol";

contract ContentCreatorVault is Modifiers {
    function depositFunds(uint16 subscriptionId) external onlyDiamond onlySubscriptionCreator(subscriptionId) {
        // Deposit funds into the contract

    }
    function withdrawFunds(uint16 subscriptionId) external onlyDiamond onlySubscriptionCreator(subscriptionId) {
        // Withdraw funds from the contract

    }

    
}