// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./HouseRegistry.sol";

contract HouseRegistryExt is HouseRegistry {

    function listHouseSimple(uint _price, uint _area, string memory _houseAddress) public canOwnerAdd{
        listHouse(_price, _area, msg.sender, _houseAddress);
    }
    function buyHouseWithETH(uint _houseId) external payable{
        require(msg.value >= houses[_houseId].price);
        payable(msg.sender).transfer(msg.value - houses[_houseId].price);
        houses[_houseId].bayerAddress = msg.sender;
        payable(houses[_houseId].sellerAddress).transfer(msg.value);
    }
}