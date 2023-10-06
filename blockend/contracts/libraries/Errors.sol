// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

library Errors {
    error EventCreditsMustBeGreaterThanPrevious();
    error CallerCanOnlyBeDiamond(address caller, address diamondContract);
    error CallerNotSubscriptionCreator(address caller, uint16 subscriptionId);
    error DeadlineMustBeGreaterThanPrevious();
    error SubscriptionNotInitialized(uint16 subscriptionId);
}
