// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import { DataTypes as Types } from "./DataTypes.sol";

struct AppStorage {
    address admin;
    uint numOfSubscriptions;
    uint numOfSubscribers; // total number of subscribers
    mapping(uint16 => Types.Subscription) subscriptions;
    mapping(address => Types.Subscriber) subscribers;
    mapping(bytes => bool) usedSignatures;
}
