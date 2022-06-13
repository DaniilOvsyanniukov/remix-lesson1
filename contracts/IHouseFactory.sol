// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)

pragma solidity ^0.8.2;

interface IHouseFactory {
    function createHouse(
        uint256 id_,
        uint256 serialNumber_,
        uint256 price_,
        uint256 priceDai_,
        uint256 area_,
        address sellerAddress_,
        address buyerAddress_,
        string memory houseAddress_
    ) external;

    function getTokAddress() external view returns (address);
}
