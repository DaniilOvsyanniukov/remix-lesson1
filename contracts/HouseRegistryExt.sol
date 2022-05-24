// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.1;

import './HouseRegistry.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import './token/IHouseToken.sol';

contract HouseRegistryExt is HouseRegistry {
    address private daiAddress = 0x9bF88fAe8CF8BaB76041c1db6467E7b37b977dD7;
    bool approved;

    event IsTrunsactionSucces (string message);  
    event IsTrunsactionApproved (string message);  
    event testevent (uint message);

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
        if(msg.value > HouseToken(houses[_houseId]).price()){
            payable(msg.sender).transfer(msg.value - HouseToken(houses[_houseId]).price());}
        HouseToken(houses[_houseId]).changeBuyerAddress(msg.sender);
        payable(HouseToken(houses[_houseId]).sellerAddress()).transfer(HouseToken(houses[_houseId]).price());
        emit IsTrunsactionSucces('Transactions succesful');
    }

    function approveTransaction(address spender, uint value, address _daiAddress) external {
        daiAddress = _daiAddress;
        IERC20(daiAddress).approve(
            spender,
            value
        );
        
        approved = true;
        emit IsTrunsactionApproved('transaction approved');
    }

    function buyHouseWithDai(uint256 _houseId) external {
        require(approved, 'transaction dont approve');
        IERC20(daiAddress).transferFrom(
            msg.sender,
            HouseToken(houses[_houseId]).sellerAddress(),
            HouseToken(houses[_houseId]).price()
        );
        HouseToken(houses[_houseId]).changeBuyerAddress(msg.sender);
        emit IsTrunsactionSucces('Transactions succesful');
    }

    // function testfunctionext(address owner, address spender, address _daiAddress) external {
    //     uint count = IERC20(daiAddress).allowance(owner, spender);
    //     // uint count = IERC20(daiAddress).balanceOf(spender);
    //     emit testevent(count);
    // }
}
