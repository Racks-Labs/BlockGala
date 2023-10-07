// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import { AppStorage } from "blockend/contracts/libraries/AppStorage.sol";
import { Modifiers } from "blockend/contracts/libraries/Modifiers.sol";
import { CryptographyInfra } from "blockend/contracts/utils/CryptographyInfra.sol";
import { Constants } from "blockend/contracts/libraries/Constants.sol";

contract LiquidSubscriptionFacet is PaymentInfra, Modifiers {
    // Auction logic   

    function buyLiquidSubscription(uint16 subscriptionId, uint256 paidInDollars, uint256 mevLimitTimestamp) onlyDiamond isSubscriptionValid(subscriptionId) public {
        // Claim liquid subscription
        require(block.timestamp <= mevLimitTimestamp, "Payment expired");
        require(paidInDollars > 0, "Amount must be greater than 0");
        require(!s.subscribers[msg.sender][subscriptionId], "Already subscribed");

        (bool success) = USDC.transferFrom(user, address(this), paidInDollars);
        require(success, "Transfer failed");

        s.subscribers[msg.sender][subscriptionId] = true;
        s.subscriptions[subscriptionId].dollarsAdquired += paidInDollars;
        s.subscriptions[subscriptionId].usersClaimed += 1;

        emit Events.SubscriptionClaimed(subscriptionId, msg.sender, paidInDollars);
    }

    function buyLiquidSubscriptionPermit(uint16 subscriptionId, uint256 paidInDollars, uint256 limitTimestamp, bytes32 r, bytes32 _s, uint8 v) onlyDiamond isSubscriptionValid(subscriptionId) public {
        // Claim liquid subscription with Permit, so you can save gas on approve
        require(block.timestamp <= limitTimestamp, "Payment expired");
        require(!usedSignatures[signature], "Signature already used"); 
        require(amount > 0, "Amount must be greater than 0");
        require(!s.subscribers[msg.sender][subscriptionId], "Already subscribed");

        IERC20Permit(USDC).permit(user, address(this), amount, limitTimestamp, v, r, _s);
        (bool success) = USDC.transferFrom(user, address(this), amount);

        s.usedSignatures[signature] = true;

        s.subscribers[msg.sender][subscriptionId] = true;
        s.subscriptions[subscriptionId].dollarsAdquired += paidInDollars;

        emit Events.SubscriptionClaimed(subscriptionId, msg.sender, paidInDollars);
    }

    function buyLiquidSubscriptionMetaTx(uint16 subscriptionId, uint256 paidInDollars, uint256 limitTimestamp, bytes signature) onlyDiamond isSubscriptionValid(subscriptionId) public {
        // Claim liquid subscription with meta transaction signed by EIP712
        require(block.timestamp <= limitTimestamp, "Payment expired");
        require(!usedSignatures[signature], "Signature already used"); 
        require(amount > 0, "Amount must be greater than 0");
        require(!s.subscribers[msg.sender][subscriptionId], "Already subscribed");

        s.usedSignatures[signature] = true;

        require(_verifySignature({
            user: msg.sender,
            amount: paidInDollars,
            limitTimestamp: limitTimestamp,
            signature: signature
        }), "Invalid signature");

        s.subscribers[msg.sender][subscriptionId] = true;
        s.subscriptions[subscriptionId].dollarsAdquired += paidInDollars;

        emit Events.SubscriptionClaimed(subscriptionId, msg.sender, paidInDollars);
    }
}