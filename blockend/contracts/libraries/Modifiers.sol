// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {AppStorage} from "blockend/contracts/libraries/AppStorage.sol";
import {Errors} from "blockend/contracts/libraries/Errors.sol";

contract Modifiers {
    AppStorage internal s;

    modifier onlyDiamond() {
        if (
            msg.sender != address(this))
            revert Errors.CallerCanOnlyBeDiamond(msg.sender, address(this));
        _;
    }

    modifier onlySubscriptionCreator(uint16 subscriptionId) {
        if (s.subscriptions[subscriptionId].creator != msg.sender)
            revert Errors.CallerNotSubscriptionCreator(msg.sender, subscriptionId);
        _;
    }

    modifier isSubscriptionValid(uint16 subscriptionId) {
        if (s.subscriptions[subscriptionId].deadline == 0)
            revert Errors.SubscriptionNotInitialized(subscriptionId);
        _;
    }
}