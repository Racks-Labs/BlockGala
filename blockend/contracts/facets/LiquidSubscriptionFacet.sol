// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import { AppStorage } from "../libraries/AppStorage.sol";
import { Modifiers } from "../libraries/Modifiers.sol";
import { CryptographyInfra } from "../utils/CryptographyInfra.sol";
import {DataTypes as Types} from "../libraries/DataTypes.sol";
import {Events} from "../libraries/Events.sol";
import {Constants} from "../libraries/Constants.sol";
import {IERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract LiquidSubscriptionFacet is CryptographyInfra, Modifiers {
    // Auction logic   

    /**
     * @notice Creates a new subscription
     * @param subscriptionId ID that maps to a subscription
     * @param config Initial values for the subscription
     */
    function buyLiquidSubscription(uint16 subscriptionId, uint256 paidInDollars, uint256 mevLimitTimestamp) onlyDiamond isSubscriptionValid(subscriptionId) public {
        // Claim liquid subscription
        require(block.timestamp <= mevLimitTimestamp, "Payment expired");
        require(paidInDollars == s.subscriptions[subscriptionId].subscriptionPrice, "Invalid amount");
        require(!s.subscribers[msg.sender].isSubscriber[subscriptionId], "Already subscribed");

        (bool success) = Constants.USDC.transferFrom(msg.sender, address(this), paidInDollars);
        require(success, "Transfer failed");

        initSubscriptionInfoToSubscriber(subscriptionId, paidInDollars);

        emit Events.SubscriptionClaimed(subscriptionId, msg.sender, paidInDollars);
    }


    /**
     * @dev Permit allows us to save gas on approve, by signing the transaction with EIP712
     * @param r These 3 are cryptographic variables, take part of the signature, used to validate the signature comes from certain signer
     * @param _s 
     * @param v 
     */
    function buyLiquidSubscriptionPermit(uint16 subscriptionId, uint256 paidInDollars, uint256 limitTimestamp, bytes32 r, bytes32 _s, uint8 v) onlyDiamond isSubscriptionValid(subscriptionId) public {
        require(block.timestamp <= limitTimestamp, "Payment expired");
        require(paidInDollars > 0, "Amount must be greater than 0");
        require(!s.subscribers[msg.sender].isSubscriber[subscriptionId], "Already subscribed");

        IERC20Permit(address(Constants.USDC)).permit(msg.sender, address(this), paidInDollars, limitTimestamp, v, r, _s);
        (bool success) = Constants.USDC.transferFrom(msg.sender, address(this), paidInDollars);

        initSubscriptionInfoToSubscriber(subscriptionId, paidInDollars);

        emit Events.SubscriptionClaimed(subscriptionId, msg.sender, paidInDollars);
    }

    /**
     * @dev Meta transactions allow us to have a relayer pay for the transaction or a subscription organizatior to pay for the subscription
     */
    function buyLiquidSubscriptionMetaTx(uint16 subscriptionId, uint256 paidInDollars, uint256 limitTimestamp, bytes memory signature) onlyDiamond isSubscriptionValid(subscriptionId) public {
        // Claim liquid subscription with meta transaction signed by EIP712
        require(block.timestamp <= limitTimestamp, "Payment expired");
        require(!s.usedSignatures[signature], "Signature already used"); 
        require(paidInDollars > 0, "Amount must be greater than 0");
        require(!s.subscribers[msg.sender].isSubscriber[subscriptionId], "Already subscribed");

        s.usedSignatures[signature] = true;

        require(_verifySignature({
            user: msg.sender,
            amount: paidInDollars,
            limitTimestamp: limitTimestamp,
            signature: signature,
            signer: s.admin
        }), "Invalid signature");

        initSubscriptionInfoToSubscriber(subscriptionId, paidInDollars);

        emit Events.SubscriptionClaimed(subscriptionId, msg.sender, paidInDollars);
    }

    function initSubscriptionInfoToSubscriber(uint16 subscriptionId, uint256 paidInDollars) internal {
        s.subscribers[msg.sender].isSubscriber[subscriptionId] = true;
        s.subscriptions[subscriptionId].dollarsAdquired += paidInDollars;
        s.subscriptions[subscriptionId].usersClaimed += 1;

        s.subscribers[msg.sender].subscriptionsIds.push(subscriptionId);
        Types.SubscriptionInfo storage newSubscriptionInfo = s.subscribers[msg.sender].subscriptionInfo[subscriptionId];

        newSubscriptionInfo.buyDate = block.timestamp;
        newSubscriptionInfo.expiration = block.timestamp + s.subscriptions[subscriptionId].subscriptionLength;
        newSubscriptionInfo.timesBought++;
        newSubscriptionInfo.costPerSubscription = s.subscriptions[subscriptionId].subscriptionPrice;

        s.subscriptions[subscriptionId].subscriptionVault.deposit(paidInDollars, msg.sender);
    }
}