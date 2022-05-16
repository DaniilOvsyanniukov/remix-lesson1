// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import './HouseRegistry.sol';
import './token/IERC20.sol';
import './token/IHouseToken.sol';

contract HouseRegistryExt is HouseRegistry {
    address private daiAddress = 0x9bF88fAe8CF8BaB76041c1db6467E7b37b977dD7;

    function listHouseSimple(
        uint256 _price,
        uint256 _priceDai,
        uint256 _area,
        string memory _houseAddress
    ) public canOwnerAdd {
        listHouse(_price, _priceDai, _area, msg.sender, _houseAddress);
    }

    function buyHouseWithETH(uint256 _houseId) external payable {
        require(msg.value >= HouseToken(houses[_houseId]).getPrice(), 'insufficient funds');
        payable(msg.sender).transfer(msg.value - HouseToken(houses[_houseId]).getPrice());
        HouseToken(houses[_houseId])._changeBuyerAddress(msg.sender);
        payable(HouseToken(houses[_houseId]).getSellerAddress()).transfer(msg.value);
    }

    function buyHouseWithDai(uint256 _houseId) external {
        IERC20(daiAddress).transferFrom(
            msg.sender,
            HouseToken(houses[_houseId]).getSellerAddress(),
            HouseToken(houses[_houseId]).getPrice()
        );
        HouseToken(houses[_houseId]).changeBuyerAddress(msg.sender);
    }
}
