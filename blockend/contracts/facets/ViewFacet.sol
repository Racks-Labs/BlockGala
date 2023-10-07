// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Modifiers} from "blockend/contracts/libraries/AppStorage.sol";

contract ViewFacet is Modifiers {

    function getAmountOfSubscriptionsBoughtCost(address _blockGalaUser) external view returns (uint256 amount) {
        uint amount;
        uint[] memory _subscriptionIds = s.subscribers[_blockGalaUser].subscriptionIds;

        for (uint i = 0; i < _subscriptionIds.length; i++) {
            uint id = _subscriptionIds[i];

            uint timesBought = s.subscribers[_blockGalaUser].subscriptionInfo[id].timesBought;
            uint costPerSubscription = s.subscribers[_blockGalaUser].subscriptionInfo[id].costPerSubscription;
            
            amount += costPerSubscription * timesBought;
        }
        
    }
}