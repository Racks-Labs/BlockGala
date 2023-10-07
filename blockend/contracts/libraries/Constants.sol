// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.19;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import { IERC4626 } from "@openzeppelin/contracts/interfaces/IERC4626.sol";

library Constants {
    uint constant MAX_TIME_DIFF_TIMELOCK = 1 days;
    IERC20 constant USDC = IERC20(0xe3d5cA6861A5cABD30AAAF78333b0Cc7Ea809DFF); // USDC mock
    address constant EVENT_COLLECTION_IMPLEMENTATION = 0x8B19AfD24d9c02d394154321389Cef1bC2A3cff3; // arthera address
    address constant ORGANIZER_VAULT_IMPLEMENTATION = 0x1D3a9936bFb01152D6C4b901C220C3C97272777E; // arthera address
}
