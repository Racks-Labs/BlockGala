// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import { AppStorage } from "../libraries/AppStorage.sol";
import { Modifiers } from "../libraries/Modifiers.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {CryptographyInfra} from "../utils/CryptographyInfra.sol";

contract RedeemsFacet is Modifiers, CryptographyInfra {
    // Meta transaction logic for unique codes and verification of signatures for liquid events 


    /**
     * @dev Function to call from server to validate certain person has access to an event
     * @notice Function to redeem event credit access (token gating) for a specific event
     * @dev Use this when you want to do it for yourself
     * @param signature Done by trusted private key, which public key is stored in `s.admin`
     */
    function redeemEventCredit(uint16 subscriptionId, uint256 eventCreditId, address redeemer, bytes memory signature, uint256 limitTimestamp) external onlyDiamond isSubscriptionValid(subscriptionId) onlySubscriptors(subscriptionId) isEventCreditIdValid(subscriptionId, eventCreditId) {
        // redeem event credit
        require(!s.usedSignatures[signature], "Signature already used");
        require(limitTimestamp >= block.timestamp, "Signature expired");
        require(s.subscriptions[subscriptionId].eventCredits[eventCreditId].isClaimed[redeemer] == false, "Event credit not claimed");
        require(s.subscriptions[subscriptionId].eventCredits[eventCreditId].isRedeemed[redeemer] == true, "Event credit already redeemed");

        require(_verifySignatureRedeemer({
            user: redeemer,
            subscriptionId: subscriptionId,
            eventCreditId: eventCreditId,
            limitTimestamp: limitTimestamp,
            signature: signature,
            signer: s.admin
        }), "Invalid signature");

        s.usedSignatures[signature] = true;

        s.subscriptions[subscriptionId].eventCredits[eventCreditId].isRedeemed[redeemer] = true;
    }


    /**
     * @dev 
     */
    function redeemEventCreditByNFT(uint16 subscriptionId, uint256 eventCreditId, uint256 tokenId) external onlyDiamond isSubscriptionValid(subscriptionId) onlySubscriptors(subscriptionId) isEventCreditIdValid(subscriptionId, eventCreditId) {
        // redeem event credit
        require(s.subscriptions[subscriptionId].eventCredits[eventCreditId].isClaimed[msg.sender] == false, "Event credit not claimed");
        require(s.subscriptions[subscriptionId].eventCredits[eventCreditId].isRedeemed[msg.sender] == true, "Event credit already redeemed");
        IERC721 eventCollection = s.subscriptions[subscriptionId].eventCredits[eventCreditId].eventNFTCollection;

        require(eventCollection.ownerOf(tokenId) == msg.sender, "Not owner of NFT");

        eventCollection.burn(tokenId);

        s.subscriptions[subscriptionId].eventCredits[eventCreditId].isNFT[msg.sender] = false;
        s.subscriptions[subscriptionId].eventCredits[eventCreditId].isRedeemed[msg.sender] = true;
    }
}