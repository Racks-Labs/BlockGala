// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

library DataTypes {

    struct Subscription {
        address creator;
        uint256 startTime;
        uint256 deadline;
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
    }

    struct Subscriber {
        uint256[] subscriptionsIds;
        uint256 eventCredits; // total number of event credits accrued
        mapping(uint256 subscriptionId => bool) isSubscriber;
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

    struct TimeLockFunc {
        uint256 time;
        string name;
        string description;
    }
}