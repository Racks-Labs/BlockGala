// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {LibDiamond} from "blockend/libraries/LibDiamond.sol";
import {Errors} from "blockend/libraries/Errors.sol";
import {Constants} from "blockend/libraries/Constants.sol";

struct AppStorage {
    address admin;
}
