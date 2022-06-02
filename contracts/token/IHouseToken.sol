// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)

pragma solidity ^0.8.2;

import '@openzeppelin/contracts/token/ERC721/IERC721.sol';

interface IHouseToken is IERC721 {
    function changeBuyerAddress(address buyerAddress) external;

    function delistHouse() external;
}
