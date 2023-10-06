// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

library DataTypes {

    struct Subscription {
        address creator;
        uint256 startTime;
        uint256 deadline;
        uint256 eventCreditsPromised; // Number of tokens/credits for attending events
        mapping(uint256 eventCreditId => EventCredit) eventCredits;
        uint256 lastEventClaimed; // ID or timestamp of the last event claimed
        uint256 usersClaimed; // Number of users who have bought the subscription
        bool isCanceled;
        string organizationName;
        string name;
        string description;
    }

    struct Subscriber {
        address subscriber;
        uint256[] subscriptionsIds;
        uint256 eventCredits; // total number of event credits accrued
    }

    struct EventCredit {
        uint256 subscriptionId;
        uint256 eventCreditId;
        string name;
        string description;
        uint256 numOfClaims;
        uint256 numOfResells;
    }
}