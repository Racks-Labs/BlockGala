// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;


interface IDiamond {
    struct Facet {
        address facetAddress;
        bytes4[] functionSelectors;
    }
    struct FacetCut {
        address facetAddress;
        FacetCutAction action;
        bytes4[] functionSelectors;
    }
    enum FacetCutAction {
        Add,
        Replace,
        Remove
    }

    function facets() external view returns (Facet[] memory facets_);

    function facetFunctionSelectors(
        address _facet
    ) external view returns (bytes4[] memory _facetFunctionSelectors);

    function facetAddresses()
        external
        view
        returns (address[] memory facetAddresses_);

    function facetAddress(
        bytes4 _functionSelector
    ) external view returns (address facetAddress_);

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes memory data
    ) external returns (bytes4);

    function diamondCut(
        FacetCut[] calldata _diamondCut,
        address _init,
        bytes calldata _calldata
    ) external;

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function asset() external view returns (address);

    function convertToAssets(uint256 shares) external view returns (uint256);

    function convertToShares(uint256 assets) external view returns (uint256);

    function decimals() external view returns (uint8);

    function deposit(
        uint256 assets,
        address receiver
    ) external returns (uint256);

    function maxDeposit(address) external view returns (uint256);

    function maxMint(address) external view returns (uint256);

    function maxRedeem(address owner) external view returns (uint256);

    function maxWithdraw(address owner) external view returns (uint256);

    function mint(uint256 shares, address receiver) external returns (uint256);

    function previewDeposit(uint256 assets) external view returns (uint256);

    function previewMint(uint256 shares) external view returns (uint256);

    function previewRedeem(uint256 shares) external view returns (uint256);

    function previewWithdraw(uint256 assets) external view returns (uint256);

    function redeem(
        uint256 shares,
        address receiver,
        address owner
    ) external returns (uint256);

    function totalAssets() external view returns (uint256);

    function totalSupply() external view returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function withdraw(
        uint256 assets,
        address receiver,
        address owner
    ) external returns (uint256);

    function approve(address to, uint256 tokenId) external;

    function balanceOf(address owner) external view returns (uint256);

    function burn(uint256 tokenId) external;

    function changeBaseUri(string memory _newBaseURI) external;

    function diamondAddress() external view returns (address);

    function getApproved(uint256 tokenId) external view returns (address);

    function initialize(
        string memory name_,
        string memory symbol_,
        string memory description_
    ) external;

    function initializes(
        string memory _name,
        string memory _symbol,
        string memory _description
    ) external;

    function isApprovedForAll(
        address owner,
        address operator
    ) external view returns (bool);

    function mint(address to, uint256 quantity) external;

    function name() external view returns (string memory);

    function ownerOf(uint256 tokenId) external view returns (address);

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) external;

    function setApprovalForAll(address operator, bool approved) external;

    function supportsInterface(bytes4 interfaceId) external view returns (bool);

    function symbol() external view returns (string memory);

    function tokenURI(uint256 tokenId) external view returns (string memory);

    function transferFrom(address from, address to, uint256 tokenId) external;

    struct EventCreditConfig {
        string name;
        string description;
    }

    function changeDescription(
        uint16 subscriptionId,
        uint16 eventCreditId
    ) external;

    function changeName(uint16 subscriptionId, uint16 eventCreditId) external;

    function claimLiquidEvent(
        uint16 subscriptionId,
        uint256 eventCreditId
    ) external;

    function createLiquidEvent(
        uint16 subscriptionId,
        EventCreditConfig memory config,
        uint256 mevDeadline
    ) external;

    function proposeEventCreditNameDescriptionChange(
        string memory newName,
        string memory newDescription,
        uint16 subscriptionId,
        uint16 eventCreditId
    ) external;

    function buyLiquidSubscription(
        uint16 subscriptionId,
        uint256 paidInDollars,
        uint256 mevLimitTimestamp
    ) external;

    function buyLiquidSubscriptionMetaTx(
        uint16 subscriptionId,
        uint256 paidInDollars,
        uint256 limitTimestamp,
        bytes memory signature
    ) external;

    function buyLiquidSubscriptionPermit(
        uint16 subscriptionId,
        uint256 paidInDollars,
        uint256 limitTimestamp,
        bytes32 r,
        bytes32 _s,
        uint8 v
    ) external;

    struct SubscriptionConfig {
        address creator;
        uint256 deadline;
        uint256 eventCreditsPromised;
        string organizationName;
        string name;
        string description;
    }

    function changeDescription(
        string memory newDescription,
        uint16 subscriptionId
    ) external;

    function changeName(string memory newName, uint16 subscriptionId) external;

    function extendDeadline(
        uint256 newDeadline,
        uint16 subscriptionId
    ) external;

    function incrementPromisedEventCredits(
        uint16 subscriptionId,
        uint256 newAmount
    ) external;

    function proposeNameDescriptionChange(
        string memory newName,
        string memory newDescription,
        uint16 subscriptionId
    ) external;

    function registerSubscription(
        uint16 subscriptionId,
        SubscriptionConfig memory config,
        uint256 mevDeadline
    ) external;

    function redeemEventCredit(
        uint16 subscriptionId,
        uint256 eventCreditId,
        address redeemer,
        bytes memory signature,
        uint256 limitTimestamp
    ) external;

    function redeemEventCreditByNFT(
        uint16 subscriptionId,
        uint256 eventCreditId,
        uint256 tokenId
    ) external;

    function mintEventCreditNFT(
        uint16 subscriptionId,
        uint256 eventCreditId,
        address to
    ) external;

    function transferEventCredit(
        uint16 subscriptionId,
        uint16 eventCreditId,
        address from,
        address to,
        uint256 tokenId
    ) external;

    function getAmountOfSubscriptionsBoughtCost(
        address _blockGalaUser
    ) external view returns (uint256 amount);
}
