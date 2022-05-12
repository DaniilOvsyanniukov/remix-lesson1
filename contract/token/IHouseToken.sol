// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)

pragma solidity ^0.8.0;

import "./IERC721.sol";

interface IHouseToken is IERC721 {
    function _delistHouse () external;

    function _getPrice() external view returns(uint);
    
    function _getId() external view returns(uint);

}