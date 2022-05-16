// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)

pragma solidity ^0.8.0;

import './IERC721.sol';

interface IHouseToken is IERC721 {
    function changeBuyerAddress(address buyerAddress) external;

    function delistHouse() external;

    function getPrice() external view returns (uint256);

    function getId() external view returns (uint256);

    function getSellerAddress() external view returns (address);
}
