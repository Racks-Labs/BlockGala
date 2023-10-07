// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import { AppStorage } from "../libraries/AppStorage.sol";
import { Modifiers } from "../libraries/Modifiers.sol";
import {Errors} from "../libraries/Errors.sol";
import { DataTypes as Types } from "../libraries/DataTypes.sol";
import {Constants} from "../libraries/Constants.sol";
import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IERC721Clonable is IERC721 {
    function initialize(string memory name, string memory symbol, string memory description) external;
}

contract LiquidEventFacet is Modifiers {
    using Clones for address;
    // Event generation logic

    function createLiquidEvent(uint16 subscriptionId, Types.EventCreditConfig memory config, uint mevDeadline) external onlyDiamond onlySubscriptionCreator(subscriptionId) {
        // Create event from subscription
        require(s.subscriptions[subscriptionId].eventCreditsPromised > s.subscriptions[subscriptionId].eventCreditsCreated);

        uint256 currentEventId = s.subscriptions[subscriptionId].eventCreditsCreated;
        Types.EventCredit storage newEventCredit = s.subscriptions[subscriptionId].eventCredits[currentEventId];

        newEventCredit.subscriptionId = subscriptionId;
        newEventCredit.eventCreditId = currentEventId;
        newEventCredit.name = config.name;
        newEventCredit.description = config.description;

        // prevent function execution if mevDeadline is not met
        require(mevDeadline > block.timestamp + 2 hours);

        cloneEventNFTCollection(subscriptionId, currentEventId);

        unchecked {
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
            keccak256(abi.encode(s.subscriptions[subscriptionId].eventCredits[eventCreditId].name)) ==
            keccak256(abi.encode(newName))
        ) revert Errors.NameMustBeDifferent();
        if (
            keccak256(
                abi.encode(s.subscriptions[subscriptionId].eventCredits[eventCreditId].description)
            ) == keccak256(abi.encode(newDescription))
        ) revert Errors.DescriptionMustBeDifferent();

        s.subscriptions[subscriptionId].eventCredits[eventCreditId].timeLockFunc.name = newName;
        s.subscriptions[subscriptionId].eventCredits[eventCreditId].timeLockFunc.description = newDescription;
    }

    function changeName(uint16 subscriptionId, uint16 eventCreditId) external onlyDiamond onlySubscriptionCreator(subscriptionId) {
        // Change name of event
        uint deadlineToModify = s.subscriptions[subscriptionId].eventCredits[eventCreditId].timeLockFunc.time;
        if (deadlineToModify < block.timestamp) revert Errors.TimeLockNotMet();
        s.subscriptions[subscriptionId].eventCredits[eventCreditId].name = s.subscriptions[subscriptionId].eventCredits[eventCreditId].timeLockFunc.name;
    }

    function changeDescription(uint16 subscriptionId, uint16 eventCreditId) external onlyDiamond onlySubscriptionCreator(subscriptionId) {
        // Change description of event
        uint deadlineToModify = s.subscriptions[subscriptionId].eventCredits[eventCreditId].timeLockFunc.time;
        if (deadlineToModify < block.timestamp) revert Errors.TimeLockNotMet();
        s.subscriptions[subscriptionId].eventCredits[eventCreditId].description = s.subscriptions[subscriptionId].eventCredits[eventCreditId].timeLockFunc.description;
    }

    function claimLiquidEvent(uint16 subscriptionId, uint256 eventCreditId) external onlyDiamond isSubscriptionValid(subscriptionId) onlySubscriptors(subscriptionId) isEventCreditIdValid(subscriptionId, eventCreditId) {
        // Claim event
        require(!s.subscriptions[subscriptionId].eventCredits[eventCreditId].isClaimed[msg.sender], "Already claimed");

        s.subscriptions[subscriptionId].eventCredits[eventCreditId].numOfClaims++;
        s.subscriptions[subscriptionId].eventCredits[eventCreditId].isClaimed[msg.sender] = true;

        s.subscribers[msg.sender].eventCreditsClaimed[subscriptionId][eventCreditId] = true;

        unchecked {
            s.subscribers[msg.sender].eventCredits++;
        }
        }

    function cloneEventNFTCollection(uint16 subscriptionId, uint256 eventCreditId) private {
        address newEventNFTCollection = Constants.EVENT_COLLECTION_IMPLEMENTATION.clone();
        uint codeSize;

        assembly {
          codeSize := extcodesize(newEventNFTCollection)
        }
        
        if (newEventNFTCollection == address(0) || codeSize == 0) revert Errors.CloneFailed();

        IERC721Clonable(newEventNFTCollection).initialize(
            s.subscriptions[subscriptionId].name,
            "TEST",
            s.subscriptions[subscriptionId].description
        );

        s.subscriptions[subscriptionId].eventCredits[eventCreditId].eventNFTCollection = IERC721(newEventNFTCollection);
    }
}