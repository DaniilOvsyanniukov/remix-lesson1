// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)

pragma solidity ^0.8.2;

import './HouseToken.sol';

import '@openzeppelin/contracts/token/ERC721/IERC721.sol';

interface IHouseToken is IERC721 {
    function changeBuyerAddress(address _buyerAddress) external;

    function delistHouse() external;

    function sellerAddress() external view returns (address);

    function price() external view returns (uint256);

    function id() external view returns (uint256);

    function buyerAddress() external view returns (address);
}
