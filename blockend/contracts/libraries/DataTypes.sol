// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {IERC4626} from "@openzeppelin/contracts/interfaces/IERC4626.sol";

library DataTypes {

    struct Subscription {
        address creator;
        uint256 startTime;
        uint256 deadline;
        uint256 subscriptionPrice; // in dollars
        uint256 subscriptionLength; // in seconds
        uint256 eventCreditsCreated;
        uint256 eventCreditsPromised; // Number of tokens/credits for attending events
        mapping(uint256 eventCreditId => EventCredit) eventCredits;
        uint256 usersClaimed; // Number of users who have bought the subscription
        bool isCanceled;
        string organizationName;
        string name;
        string description;
        uint256 dollarsAdquired;
        TimeLockFunc timeLockFunc;
        IERC4626 organizerVault;
    }

    struct Subscriber {
        uint256[] subscriptionsIds;
        uint256 eventCredits; // total number of event credits accrued
        mapping(uint256 subscriptionId => bool) isSubscriber;
        mapping(uint16 subscriptionId => SubscriptionInfo) subscriptionInfo;
    }

    struct EventCredit {
        uint256 subscriptionId;
        uint256 eventCreditId;
        string name;
        string description;
        uint256 numOfClaims;
        uint256 numOfResells;
        TimeLockFunc timeLockFunc;
        mapping(address => bool) isClaimed;
        mapping(address => bool) isRedeemed;
    }

    struct SubscriptionConfig {
        address creator;
        uint256 deadline;
        uint256 eventCreditsPromised;
        string organizationName;
        string name;
        string description;
    }

    struct EventCreditConfig {
        string name;
        string description;
    }

    struct SubscriptionInfo {
        uint256 buyDate; // in seconds, last subscription purchase date
        uint256 expiration; // in seconds, last subscription expiration date
        uint256 timesBought; // how many times the subscription has been bought
        uint256 costPerSubscription; // in dollars
    }

    struct TimeLockFunc {
        uint256 time;
        string name;
        string description;
    }
}