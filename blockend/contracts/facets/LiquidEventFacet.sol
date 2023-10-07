// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import { AppStorage } from "blockend/contracts/libraries/AppStorage.sol";
import { Modifiers } from "blockend/contracts/libraries/Modifiers.sol";
import { DataTypes } from "blockend/contracts/libraries/DataTypes.sol";

contract LiquidEventFacet is Modifiers {
    // Event generation logic

    function createLiquidEvent(uint16 subscriptionId, Types.EventCreditConfig config, uint mevDeadline) external onlyDiamond onlySubscriptionCreator(subscriptionId) {
        // Create event from subscription
        require(s.subscriptions[subscriptionId].eventCreditsPromised > s.subscriptions[subscriptionId].eventCreditsCreated);

        uint256 currentEventId = s.subscriptions[subscriptionId].eventCreditsCreated;
        Types.Subscription storage newEventCredit = s.subscriptions[subscriptionId][currentEventId];

        newEventCredit.subscriptionId = subscriptionId;
        newEventCredit.eventCreditId = currentEventId;
        newEventCredit.name = config.name;
        newEventCredit.description = config.description;

        // prevent function execution if mevDeadline is not met
        require(mevDeadline > block.timestamp + 2 hours);

        unchecked {
            newEventCredit.eventCreditsCreated++;
            s.subscriptions[subscriptionId].eventCreditsCreated++;
        }
    }

    function proposeEventCreditNameDescriptionChange(
        string memory newName,
        string memory newDescription,
        uint16 subscriptionId,
        uint16 eventCreditId
    ) external onlyDiamond onlySubscriptionCreator(subscriptionId) {
        // Propose a name and description change
        if (
            keccak256(abi.encode(s.subscriptions[subscriptionId][eventCreditId].name)) ==
            keccak256(abi.encode(newName))
        ) revert Errors.NameMustBeDifferent();
        if (
            keccak256(
                abi.encode(s.subscriptions[subscriptionId][eventCreditId].description)
            ) == keccak256(abi.encode(newDescription))
        ) revert Errors.DescriptionMustBeDifferent();

        s.subscriptions[subscriptionId][eventCreditId].timeLockFunc.name = newName;
        s.subscriptions[subscriptionId][eventCreditId].timeLockFunc.description = newDescription;
    }

    function changeName(uint16 subscriptionId, uint16 eventCreditId) external onlyDiamond onlySubscriptionCreator(subscriptionId) {
        // Change name of event
        uint deadlineToModify = s.subscriptions[subscriptionId][eventCreditId].timeLockFunc.time;
        if (deadlineToModify < block.timestamp) revert Errors.TimeLockNotMet();
        s.subscriptions[subscriptionId][eventCreditId].name = s.subscriptions[subscriptionId][eventCreditId].timeLockFunc.name;
    }

    function changeDescription(uint16 subscriptionId, uint16 eventCreditId) external onlyDiamond onlySubscriptionCreator(subscriptionId) {
        // Change description of event
        uint deadlineToModify = s.subscriptions[subscriptionId][eventCreditId].timeLockFunc.time;
        if (deadlineToModify < block.timestamp) revert Errors.TimeLockNotMet();
        s.subscriptions[subscriptionId][eventCreditId].description = s.subscriptions[subscriptionId][eventCreditId].timeLockFunc.description;
    }

    function claimLiquidEvent(uint16 subscriptionId, uint256 eventCreditId) external onlyDiamond isSubscriptionValid(subscriptionId) onlySubscriptors(subscriptionId) isEventCreditIdValid(subscriptionId, eventCreditId) {
        // Claim event
        require(!s.subscribers[subscriptionId].eventCredits[eventCreditId].isClaimed[msg.sender], "Already claimed");
        
        s.subscriptions[subscriptionId][eventCreditId].numOfClaims++;
        s.subscribers[subscriptionId].eventCredits[eventCreditId].isClaimed[msg.sender] = true;
    }
}