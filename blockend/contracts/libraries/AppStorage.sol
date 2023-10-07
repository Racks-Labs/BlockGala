// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {LibDiamond} from "blockend/contracts/libraries/LibDiamond.sol";
import {Errors} from "blockend/contracts/libraries/Errors.sol";
import {Constants} from "blockend/contracts/libraries/Constants.sol";
import { DataTypes as Types } from "blockend/contracts/libraries/DataTypes.sol";

struct AppStorage {
    address admin;
    uint numOfSubscriptions;
    uint numOfSubscribers; // total number of subscribers
    mapping(uint16 => Types.Subscription) subscriptions;
    mapping(address => Types.Subscriber) subscribers;
    mapping (bytes => bool) usedSignatures;
}
