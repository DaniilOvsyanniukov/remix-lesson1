// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.2;

import './HouseRegistry.sol';
import '@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol';
import './token/IHouseToken.sol';
import '@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol';

contract HouseRegistryExt is Initializable, HouseRegistry {
    function init(address _daiAddress, address _factoryAddress) public initializer {
        daiAddress = _daiAddress;
        initialize(_factoryAddress);
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
        require(msg.value >= IHouseToken(houses[_houseId]).price(), 'value less than cost');
        if (msg.value > IHouseToken(houses[_houseId]).price()) {
            payable(msg.sender).transfer(msg.value - IHouseToken(houses[_houseId]).price());
        }
        IHouseToken(houses[_houseId]).changeBuyerAddress(msg.sender);
        payable(IHouseToken(houses[_houseId]).sellerAddress()).transfer(
            IHouseToken(houses[_houseId]).price()
        );
        emit IsTransactionSucces(
            'Transactions succesful',
            IHouseToken(houses[_houseId]).buyerAddress()
        );
    }

    function buyHouseWithDai(uint256 _houseId) external {
        IERC20Upgradeable(daiAddress).transferFrom(
            msg.sender,
            IHouseToken(houses[_houseId]).sellerAddress(),
            IHouseToken(houses[_houseId]).price()
        );
        IHouseToken(houses[_houseId]).changeBuyerAddress(msg.sender);
        emit IsTransactionSucces(
            'Transactions succesful',
            IHouseToken(houses[_houseId]).buyerAddress()
        );
    }
}
