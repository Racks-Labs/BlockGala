// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import { AppStorage } from "blockend/contracts/libraries/AppStorage.sol";
import { Modifiers } from "blockend/contracts/libraries/Modifiers.sol";
import {CryptographyInfra} from "blockend/contracts/utils/CryptographyInfra.sol";

contract MetaTransactionsFacet is Modifiers {
    // Meta transaction logic for unique codes and verification of signatures for liquid events 

    function redeemEventCredit(uint16 subscriptionId, uint256 eventCreditId, address redeemer, bytes memory signature, uint256 limitTimestamp) external onlyDiamond isSubscriptionValid(subscriptionid) onlySubscriptors(subscriptionId) isEventCreditIdValid(subscriptionId, eventCreditId) {
        // redeem event credit
        require(!s.usedSignatures[signature], "Signature already used");
        require(limitTimestamp >= block.timestamp, "Signature expired");
        require(s.subscriptions[subscriptionId][eventCreditId].isClaimed[account] == false, "Event credit not claimed");
        require(s.subscriptions[subscriptionId][eventCreditId].isRedeemed[account] == true, "Event credit already redeemed");

        _verifySignatureRedeemer({
            user: redeemer,
            subscriptionId: subscriptionId,
            eventCreditId: eventCreditId,
            limitTimestamp: limitTimestamp,
            signature: signature
        });

        s.usedSignatures[signature] = true;

        s.subscriptions[subscriptionId][eventCreditId].isRedeemed[account] = true;
    }
}