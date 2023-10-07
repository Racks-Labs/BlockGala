// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Test} from "../lib/forge-std/src/Test.sol";
import {IDiamond} from "../contracts/interfaces/IDiamond.sol";
import {DiamondCutFacet} from "../contracts/facets/DiamondCutFacet.sol";
import {Diamond} from "../contracts/Diamond.sol";
import {DiamondLoupeFacet} from "../contracts/facets/DiamondLoupeFacet.sol";
import {LiquidEventFacet} from "../contracts/facets/LiquidEventFacet.sol";
import {LiquidSubscriptionFacet} from "../contracts/facets/LiquidSubscriptionFacet.sol";
import {OrganizerFacet} from "../contracts/facets/OrganizerFacet.sol";
import {RedeemsFacet} from "../contracts/facets/RedeemsFacet.sol";
import {TradingFacet} from "../contracts/facets/TradingFacet.sol";
import {ViewFacet} from "../contracts/facets/ViewFacet.sol";
import {EventCollection} from "../contracts/EventNFTCollection/EventCollection.sol";
import {SubscriptorsVault} from "../contracts/vault/SubscriptorsVault.sol";
import {console} from "../lib/forge-std/src/console.sol";

contract DeployProtocol is Test {

    // DiamondLogic contracts
    //IDiamond public diamond;
    address public _diamond;
    address public _diamondLoupe;
    address public _diamondCut;

    // Core protocol logic contracts
    address public liquidEventFacet;
    address public liquidSubscriptionFacet;
    address public organizerFacet;
    address public redeemsFacet;
    address public tradingFacet;
    address public viewFacet;

    // Function Selectors of each contract
    bytes4[] internal diamondSelectors;
    bytes4[] internal loupeSelectors;
    bytes4[] internal cutSelectors;
    bytes4[] internal liquidEventSelectors;
    bytes4[] internal liquidSubscriptionSelectors;
    bytes4[] internal organizerSelectors;
    bytes4[] internal redeemsSelectors;
    bytes4[] internal tradingSelectors;
    bytes4[] internal viewSelectors;

    function getSelector(string memory _func) internal pure returns (bytes4) {
        return bytes4(keccak256(bytes(_func)));
    }

    function run() external {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address owner = vm.addr(privateKey);

        console.log("Deploying contracts, with address: ", owner);

        vm.startBroadcast(privateKey); // pass the input key

        // Selectors per contract
        loupeSelectors = [
            IDiamond.facets.selector,
            IDiamond.facetFunctionSelectors.selector,
            IDiamond.facetAddresses.selector,
            IDiamond.facetAddress.selector
        ];
        liquidEventSelectors = [
            IDiamond.createLiquidEvent.selector,
            IDiamond.proposeEventCreditNameDescriptionChange.selector,
            getSelector("changeName(uint16,uint16)"),
            getSelector("changeDescription(uint16,uint16)"),
            IDiamond.claimLiquidEvent.selector
        ];
        liquidSubscriptionSelectors = [
            IDiamond.buyLiquidSubscription.selector,
            IDiamond.buyLiquidSubscriptionPermit.selector,
            IDiamond.buyLiquidSubscriptionMetaTx.selector
        ];
        organizerSelectors = [
            IDiamond.registerSubscription.selector,
            IDiamond.proposeNameDescriptionChange.selector,
            getSelector("changeName(string,uint16)"),
            getSelector("changeDescription(string,uint16)"),  
            IDiamond.extendDeadline.selector,
            IDiamond.incrementPromisedEventCredits.selector
        ];
        redeemsSelectors = [
            IDiamond.redeemEventCredit.selector,
            IDiamond.redeemEventCreditByNFT.selector
        ];
        tradingSelectors = [
            IDiamond.mintEventCreditNFT.selector,
            IDiamond.transferEventCredit.selector
        ];
        viewSelectors = [
            IDiamond.getAmountOfSubscriptionsBoughtCost.selector
        ];

        _diamondCut = address(new DiamondCutFacet());
        _diamond = address(new Diamond(0x5b73C5498c1E3b4dbA84de0F1833c4a029d90519, _diamondCut)); // precalculated address added
        _diamondLoupe = address(new DiamondLoupeFacet());
        liquidEventFacet = address(new LiquidEventFacet());
        liquidSubscriptionFacet = address(new LiquidSubscriptionFacet());
        organizerFacet = address(new OrganizerFacet());
        redeemsFacet = address(new RedeemsFacet());
        tradingFacet = address(new TradingFacet());
        viewFacet = address(new ViewFacet());
        vm.stopBroadcast();

        IDiamond.FacetCut[] memory cut;

        cut = new IDiamond.FacetCut[](7);

        cut[0] = (
            IDiamond.FacetCut({
                facetAddress: _diamondLoupe,
                action: IDiamond.FacetCutAction.Add,
                functionSelectors: loupeSelectors
            })
        );

        cut[1] = (
            IDiamond.FacetCut({
                facetAddress: liquidEventFacet,
                action: IDiamond.FacetCutAction.Add,
                functionSelectors: liquidEventSelectors
            })
        );

        cut[2] = (
            IDiamond.FacetCut({
                facetAddress: liquidSubscriptionFacet,
                action: IDiamond.FacetCutAction.Add,
                functionSelectors: liquidSubscriptionSelectors
            })
        );

        cut[3] = (
            IDiamond.FacetCut({
                facetAddress: organizerFacet,
                action: IDiamond.FacetCutAction.Add,
                functionSelectors: organizerSelectors
            })
        );

        cut[4] = (
            IDiamond.FacetCut({
                facetAddress: redeemsFacet,
                action: IDiamond.FacetCutAction.Add,
                functionSelectors: redeemsSelectors
            })
        );

        cut[5] = (
            IDiamond.FacetCut({
                facetAddress: tradingFacet,
                action: IDiamond.FacetCutAction.Add,
                functionSelectors: tradingSelectors
            })
        );

        cut[6] = (
            IDiamond.FacetCut({
                facetAddress: viewFacet,
                action: IDiamond.FacetCutAction.Add,
                functionSelectors: viewSelectors
            })
        );

        assertNotEq(_diamond, address(0));
        assertNotEq(_diamondLoupe, address(0));
        assertNotEq(_diamondCut, address(0));
        assertNotEq(liquidEventFacet, address(0));
        assertNotEq(liquidSubscriptionFacet, address(0));
        assertNotEq(organizerFacet, address(0));
        assertNotEq(redeemsFacet, address(0));
        assertNotEq(tradingFacet, address(0));
        assertNotEq(viewFacet, address(0));

        IDiamond diamond = IDiamond(payable(_diamond));
        diamond.diamondCut(cut, address(0x0), "");

        IDiamond.Facet[] memory facets = diamond.facets();
        
        // @dev first facet is DiamondCutFacet
        assertEq(facets.length, cut.length + 1);
        for (uint256 i = 0; i < facets.length - 1; i++) {
            assertNotEq(facets[i].facetAddress, address(0));
            assertEq(
                facets[i + 1].functionSelectors.length, cut[i].functionSelectors.length
            );
            for (uint256 y = 0; y < facets[i + 1].functionSelectors.length; y++) {
                assertEq(facets[i + 1].functionSelectors[y], cut[i].functionSelectors[y]);
            }
        }
        console.log("Diamond deployed with address: ", _diamond);
        console.log("DiamondCutFacet deployed with address: ", _diamondCut);
        console.log("DiamondLoupeFacet deployed with address: ", _diamondLoupe);
        console.log("LiquidEventFacet deployed with address: ", liquidEventFacet);
        console.log("LiquidSubscriptionFacet deployed with address: ", liquidSubscriptionFacet);
        console.log("OrganizerFacet deployed with address: ", organizerFacet);
        console.log("RedeemsFacet deployed with address: ", redeemsFacet);
        console.log("TradingFacet deployed with address: ", tradingFacet);
        console.log("ViewFacet deployed with address: ", viewFacet);
    }
}