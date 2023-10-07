// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

contract CryptographyInfra {
    function _verifySignature(
        address user,
        uint256 amount,
        uint256 limitTimestamp,
        bytes memory signature,
        address signer
    ) internal view returns(bool) {
        bytes32 messageHash = keccak256(
                    abi.encodePacked(
                        user,
                        amount,
                        limitTimestamp
                    )
                );

        return ECDSA.recover(
                MessageHashUtils.toEthSignedMessageHash(messageHash),
                signature
        ) == signer;
    }

    function _verifySignatureRedeemer(
        address user,
        uint256 subscriptionId,
        uint256 eventCreditId,
        uint256 limitTimestamp,
        bytes memory signature,
        address signer
    ) internal view returns(bool) {
        bytes32 messageHash = keccak256(
                    abi.encodePacked(
                        user,
                        subscriptionId,
                        eventCreditId,
                        limitTimestamp
                    )
                );

        return ECDSA.recover(
                MessageHashUtils.toEthSignedMessageHash(messageHash),
                signature
        ) == signer;
    }
}