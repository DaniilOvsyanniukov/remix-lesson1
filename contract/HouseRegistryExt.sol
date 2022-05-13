// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./HouseRegistry.sol";
import "./token/IERC20.sol";
import "./token/IHouseToken.sol";

contract HouseRegistryExt is HouseRegistry {

    function listHouseSimple(uint _price, uint _priceDai, uint _area, string memory _houseAddress) public canOwnerAdd{
        listHouse(_price, _priceDai, _area, msg.sender, _houseAddress);
    }
    function buyHouseWithETH(uint _houseId) external payable{
        require(msg.value >= HouseToken(houses[_houseId])._getPrice());
        payable(msg.sender).transfer(msg.value - HouseToken(houses[_houseId])._getPrice());
        HouseToken(houses[_houseId])._changeBuyerAddress(msg.sender);
        payable(HouseToken(houses[_houseId])._getSellerAddress()).transfer(msg.value);
    }

    function buyHouseWithDai(uint _houseId) external {
        IERC20(0x9bF88fAe8CF8BaB76041c1db6467E7b37b977dD7).transferFrom(msg.sender, HouseToken(houses[_houseId])._getSellerAddress(), HouseToken(houses[_houseId])._getPrice());
        HouseToken(houses[_houseId])._changeBuyerAddress(msg.sender);
    }
}