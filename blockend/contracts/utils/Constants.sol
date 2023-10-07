// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.19;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { IERC4626 } from "@openzeppelin/contracts/interfaces/IERC4626.sol";

contract Constants {
    uint constant MAX_TIME_DIFF_TIMELOCK = 1 days;
    IERC20 immutable USDC;
    IERC4626 immutable ORGANIZER_VAULT_IMPLEMENTATION;
}