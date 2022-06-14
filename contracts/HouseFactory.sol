// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)

pragma solidity ^0.8.2;

import './token/HouseToken.sol';
import './IHouseFactory.sol';

contract HouseFactory is IHouseFactory {
    mapping(address => HouseToken) public houseTokens;
    address public houseTokenAddress;

    function createHouse(
        uint256 id_,
        uint256 serialNumber_,
        uint256 price_,
        uint256 priceDai_,
        uint256 area_,
        address sellerAddress_,
        address buyerAddress_,
        string memory houseAddress_
    ) external override returns (address) {
        HouseToken house = new HouseToken(
            id_,
            serialNumber_,
            price_,
            priceDai_,
            area_,
            sellerAddress_,
            buyerAddress_,
            houseAddress_,
            false
        );
        houseTokens[address(house)] = house;
        houseTokenAddress = address(house);
        return houseTokenAddress;
    }
}
