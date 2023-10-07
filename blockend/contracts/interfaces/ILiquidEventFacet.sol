// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import { DataTypes as Types } from "../libraries/DataTypes.sol";

interface ILiquidEventFacet {
    function createLiquidEvent(uint16 subscriptionId, Types.EventCreditConfig memory config, uint mevDeadline) external;
    function proposeEventCreditNameDescriptionChange(
        string memory newName,
        string memory newDescription,
        uint16 subscriptionId,
        uint16 eventCreditId
    ) external;
    function changeName(uint16 subscriptionId, uint16 eventCreditId) external;
}