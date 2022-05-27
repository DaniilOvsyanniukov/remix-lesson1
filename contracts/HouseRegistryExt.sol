// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.1;

import './HouseRegistry.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import './token/IHouseToken.sol';

contract HouseRegistryExt is HouseRegistry {
    address public daiAddress;

    event IsTrunsactionSucces(string message, address buyerAddress);

    constructor(address _daiAddress) public {
        daiAddress = _daiAddress;
    }

    function listHouseSimple(
        uint256 _price,
        uint256 _priceDai,
        uint256 _area,
        string memory _houseAddress
    ) public canOwnerAdd {
        listHouse(_price, _priceDai, _area, msg.sender, _houseAddress);
    }

    function buyHouseWithETH(uint256 _houseId) external payable {
        require(msg.value >= HouseToken(houses[_houseId]).price(), 'value less than cost');
        if (msg.value > HouseToken(houses[_houseId]).price()) {
            payable(msg.sender).transfer(msg.value - HouseToken(houses[_houseId]).price());
        }
        HouseToken(houses[_houseId]).changeBuyerAddress(msg.sender);
        payable(HouseToken(houses[_houseId]).sellerAddress()).transfer(
            HouseToken(houses[_houseId]).price()
        );
        emit IsTrunsactionSucces(
            'Transactions succesful',
            HouseToken(houses[_houseId]).buyerAddress()
        );
    }

    function buyHouseWithDai(uint256 _houseId) external {
        IERC20(daiAddress).transferFrom(
            msg.sender,
            HouseToken(houses[_houseId]).sellerAddress(),
            HouseToken(houses[_houseId]).price()
        );
        HouseToken(houses[_houseId]).changeBuyerAddress(msg.sender);
        emit IsTrunsactionSucces(
            'Transactions succesful',
            HouseToken(houses[_houseId]).buyerAddress()
        );
    }
}
