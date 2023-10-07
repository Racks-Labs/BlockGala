// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {LibDiamond} from "blockend/contracts/libraries/LibDiamond.sol";

import {IDiamondLoupe} from "blockend/contracts/interfaces/IDiamondLoupe.sol";
import {IDiamondCut} from "blockend/contracts/interfaces/IDiamondCut.sol";
import {IERC165} from "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { IERC4626 } from "@openzeppelin/contracts/interfaces/IERC4626.sol";
import {AppStorage} from "blockend/contracts/libraries/AppStorage.sol";
import {Errors} from "blockend/contracts/libraries/Errors.sol";
import {Constants} from "blockend/contracts/utils/Constants.sol";

// See https://github.com/mudgen/diamond-2-hardhat/blob/main/contracts/Diamond.sol
// All code taken from diamond implementation, other than init code

contract Diamond is Constants {
    AppStorage internal s;

    constructor(address _protocolOwner, address _diamondCutFacet, address _usdcAddress, address _organizerVaultAddressImplementation, address _eventCollectionAddressImplementation)
        payable
    {
        LibDiamond.setProtocolOwner(_protocolOwner);
        s.admin = _contractOwner;

        // Add the diamondCut external function from the diamondCutFacet
        IDiamondCut.FacetCut[] memory cut = new IDiamondCut.FacetCut[](1);
        bytes4[] memory functionSelectors = new bytes4[](1);
        functionSelectors[0] = IDiamondCut.diamondCut.selector;
        cut[0] = IDiamondCut.FacetCut({
            facetAddress: _diamondCutFacet,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: functionSelectors
        });
        LibDiamond.diamondCut(cut, address(0), "");

        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        // adding ERC165 data
        ds.supportedInterfaces[type(IERC165).interfaceId] = true;
        ds.supportedInterfaces[type(IDiamondCut).interfaceId] = true;
        ds.supportedInterfaces[type(IDiamondLoupe).interfaceId] = true;

        // initialize the protocol AppStorage and Constants
        USDC = IERC20(_usdcAddress);
        EVENT_COLLECTION_IMPLEMENTATION = IERC721(_eventCollectionAddressImplementation);
        ORGANIZER_VAULT_IMPLEMENTATION = IERC4626(_organizerVaultAddressImplementation);
    }

    // Find facet for function that is called and execute the
    // function if a facet is found and return any value.
    fallback() external payable {
      // get facet from function selector
      address facet = selectorTofacet[msg.sig];
      require(facet != address(0));
      // Execute external function from facet using delegatecall and return any value.
      assembly {
        // copy function selector and any arguments
        calldatacopy(0, 0, calldatasize())
        // execute function call using the facet
        let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)
        // get any return value
        returndatacopy(0, 0, returndatasize())
        // return any return value or error back to the caller
        switch result
          case 0 {revert(0, returndatasize())}
          default {return (0, returndatasize())}
      }
    }
}
