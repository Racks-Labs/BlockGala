// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import { AppStorage } from "blockend/contracts/libraries/AppStorage.sol";
import { Errors } from "blockend/contracts/libraries/Errors.sol";
import { Modifiers } from "blockend/contracts/libraries/Modifiers.sol";

contract RegistryFacet is Modifiers {
    // Registry logic for corporation wanting to use the platform

    function registerSubscription() external onlyDiamond {
        // Register a subscription
    }

    function cancelSubscription(uint16 subscriptionId) external onlyDiamond onlySubscriptionCreator(subscriptionId) {
        // Cancel a subscription
        // if it is unabled without meeting deadlines, a % of the subscription time lift
        // and event credits left will compute the money the org has to pay back to users
        if (s.subscriptions[subscriptionId].deadline == 0) revert Errors.SubscriptionNotInitialized(subscriptionId);
        
        s.subscriptions[subscriptionId].isCanceled = true;
    }

    function extendDeadline(uint newDeadline, uint16 subscriptionId) external onlyDiamond {
        // Extend the deadline of a subscription
        if (s.subscriptions[subscriptionId].deadline <= newDeadline) revert Errors.DeadlineMustBeGreaterThanPrevious();
        s.subscriptions[subscriptionId].deadline = newDeadline;
    }

    function incrementPromisedEventCredits(uint16 subscriptionId, uint newAmount) external onlyDiamond {
        // Increment event credits
        if (s.subscriptions[subscriptionId].eventCreditsPromised <= newAmount) revert Errors.EventCreditsMustBeGreaterThanPrevious();
        s.subscriptions[subscriptionId].eventCreditsPromised = newAmount;
    }
}