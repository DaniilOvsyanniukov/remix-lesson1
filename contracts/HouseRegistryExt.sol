// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.2;

import './HouseRegistry.sol';
import '@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol';
import './token/IHouseToken.sol';
import '@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol';

contract HouseRegistryExt is Initializable, HouseRegistry {
    function init(address _daiAddress) public initializer {
        daiAddress = _daiAddress;
    }

    address public daiAddress;

    event IsTransactionSucces(string message, address buyerAddress);

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
        emit IsTransactionSucces(
            'Transactions succesful',
            HouseToken(houses[_houseId]).buyerAddress()
        );
    }

    function buyHouseWithDai(uint256 _houseId) external {
        IERC20Upgradeable(daiAddress).transferFrom(
            msg.sender,
            HouseToken(houses[_houseId]).sellerAddress(),
            HouseToken(houses[_houseId]).price()
        );
        HouseToken(houses[_houseId]).changeBuyerAddress(msg.sender);
        emit IsTransactionSucces(
            'Transactions succesful',
            HouseToken(houses[_houseId]).buyerAddress()
        );
    }
}
