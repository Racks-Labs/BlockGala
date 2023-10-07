// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import { Modifiers } from "blockend/contracts/libraries/Modifiers.sol";

contract TradingFacet is Modifiers {
    // P2P trading logic

    function transferEventCredit(uint16 subscriptionId, uint16 eventCreditId, address to) external onlyDiamond isSubscriptionValid(subscriptionId) isEventCreditIdValid(subscriptionId, eventCreditId) {
        // Transfer event credit to another user
    }
}