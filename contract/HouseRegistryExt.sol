// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./HouseRegistry.sol";
import "./ERC20.sol";

contract HouseRegistryExt is HouseRegistry, ERC20 {

    constructor(string memory name, string memory symbol) 
        ERC20(name, symbol) {
        // ERC20 tokens have 18 decimals 
        // number of tokens minted = n * 10^18
        uint256 n = 1000;
        _mint(msg.sender, n * 10**uint(decimals()));
    }

    function listHouseSimple(uint _price, uint _priceDai, uint _area, string memory _houseAddress) public canOwnerAdd{
        listHouse(_price, _priceDai, _area, msg.sender, _houseAddress);
    }
    function buyHouseWithETH(uint _houseId) external payable{
        require(msg.value >= houses[_houseId].price);
        payable(msg.sender).transfer(msg.value - houses[_houseId].price);
        houses[_houseId].buyerAddress = msg.sender;
        payable(houses[_houseId].sellerAddress).transfer(msg.value);
    }

    function buyHouseWithDai(uint _houseId) external payable {
        require(transferFrom(msg.sender, houses[_houseId].sellerAddress, houses[_houseId].priceDai), "Transaction failed");
        payable(houses[_houseId].buyerAddress = msg.sender);
    }
}