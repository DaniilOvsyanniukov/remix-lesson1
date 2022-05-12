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
        require(msg.value >= (houses[_houseId])._getPrice());
        payable(msg.sender).transfer(msg.value - (houses[_houseId])._getPrice());
        houses[_houseId].buyerAddress = msg.sender;
        payable(houses[_houseId].sellerAddress).transfer(msg.value);
    }

    function buyHouseWithDai(uint _houseId) external {
        IERC20(0x9bF88fAe8CF8BaB76041c1db6467E7b37b977dD7).transferFrom(msg.sender, houses[_houseId].sellerAddress, houses[_houseId].priceDai);
        houses[_houseId].buyerAddress = msg.sender;
    }
}