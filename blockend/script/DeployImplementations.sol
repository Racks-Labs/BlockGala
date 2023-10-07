// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {EventCollection} from "../contracts/EventNFTCollection/EventCollection.sol";
import {SubscriptorsVault} from "../contracts/vault/SubscriptorsVault.sol";
import {FiatTokenV2_1 as USDC} from "../contracts/mocks/USDC.sol";
/**
 * @dev need to run source env (to load the env variables)
 */

contract DeployImplementationsAndMocks is Script {
    function setUp() public {}

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address owner = vm.addr(privateKey);

        // uint64 _subscriptionId, bytes32 _gasLane, address _cordinator, address _linkAddress

        console.log("Deploying contracts, with address: ", owner);

        vm.startBroadcast(privateKey); // pass the input key

        // Deploy DaoToken, USDC, EventCollection and Vault
        USDC usdc = new USDC();
        usdc.initialize("USDC", "USDC", "USDC", 6, owner, owner, owner, owner);
        usdc.initializeV2("USDC");
        usdc.initializeV2_1(owner);
        EventCollection eventCollection = new EventCollection();
        eventCollection.initializes("Free movie", "FM+", "Gain access to any movie you desire in MovistarPlus +!");
        SubscriptorsVault vault = new SubscriptorsVault(address(0)); // no asset, deposits are by amount of dollars invested in subscriptions

        console.log("EventCollection deployed, with address: ", address(eventCollection));
        console.log("USDC deployed, with address: ", address(usdc));
        console.log("Vault deployed, with address: ", address(vault));

        vm.stopBroadcast();
    }
}