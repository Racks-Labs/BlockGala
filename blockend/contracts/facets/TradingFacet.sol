// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import { Modifiers } from "../libraries/Modifiers.sol";
import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import { Errors } from "../libraries/Errors.sol";

contract TradingFacet is Modifiers {
    // P2P trading logic

    /**
     * @dev Mint wrapper for event credit NFTs
     */
    function mintEventCreditNFT(uint16 subscriptionId, uint256 eventCreditId, address to) external onlyDiamond isSubscriptionValid(subscriptionId) isEventCreditIdValid(subscriptionId, eventCreditId) onlySubscriptors(subscriptionId) {
        // Look into implementation address, mint an event credit, and send it to the caller
        if (s.subscriptions[subscriptionId].eventCredits[eventCreditId].isNFT[msg.sender] == true)
            revert Errors.NFTAlreadyMinted();
        if (s.subscriptions[subscriptionId].eventCredits[eventCreditId].isClaimed[msg.sender] == false)
            revert Errors.EventCreditNotClaimed();
        if (s.subscriptions[subscriptionId].eventCredits[eventCreditId].isRedeemed[msg.sender] == true)
            revert Errors.EventCreditAlreadyRedeemed();

        s.subscriptions[subscriptionId].eventCredits[eventCreditId].isNFT[msg.sender] = true;
        
        IERC721 eventCollection = s.subscriptions[subscriptionId].eventCredits[eventCreditId].eventNFTCollection;

        eventCollection.mint(to, 1);
    }

    /**
     * @dev Approves have to be done directly to the NFT contract
    **/
    function transferEventCredit(uint16 subscriptionId, uint16 eventCreditId, address from, address to, uint256 tokenId) external onlyDiamond isSubscriptionValid(subscriptionId) isEventCreditIdValid(subscriptionId, eventCreditId) {
        require(!s.subscriptions[subscriptionId].eventCredits[eventCreditId].isRedeemed[from], "Event credit already redeemed");
        require(s.subscriptions[subscriptionId].eventCredits[eventCreditId].isClaimed[from], "Event credit not claimed");
        // Transfer event credit to another user

        IERC721 eventCollection = s.subscriptions[subscriptionId].eventCredits[eventCreditId].eventNFTCollection;
        eventCollection.safeTransferFrom(from, to, tokenId);

        // Move owner to be able to have ownership and redeem
        s.subscriptions[subscriptionId].eventCredits[eventCreditId].isClaimed[from] = false;
        s.subscriptions[subscriptionId].eventCredits[eventCreditId].isClaimed[to] = true;
    }

}