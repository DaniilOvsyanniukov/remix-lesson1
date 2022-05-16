// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)

pragma solidity ^0.8.0;

import './ERC721.sol';
import './IHouseToken.sol';

contract HouseToken is ERC721, IHouseToken {

    uint public id;
    uint public serialNumber;
    uint public price;
    uint public priceDai;
    uint public area;
    address public sellerAddress;
    address public buyerAddress;
    string public houseAddress;
    bool public isdelistedHouse;

    constructor(uint id_, uint serialNumber_, uint price_, uint priceDai_, 
        uint area_, address sellerAddress_, address buyerAddress_, string 
        memory houseAddress_, bool isdelistedHouse_) ERC721('HouseToken', 'HT') {
       id=id_;
       serialNumber=serialNumber_;
       price=price_;
       priceDai=priceDai_;
       area=area_;
       sellerAddress=sellerAddress_;
       buyerAddress=buyerAddress_;
       houseAddress=houseAddress_;
       isdelistedHouse=isdelistedHouse_;
    }

    function changeBuyerAddress (address buyerAddress) external override {
        buyerAddress = buyerAddress;
    }

    function delistHouse () external override {
       isdelistedHouse = true;
    }
    function getPrice() external view override returns(uint){
        return price;
    }
    function getId() external view override returns(uint){
        return id;
    }  
    function getSellerAddress() external view  override returns(address){
        return sellerAddress;
    }

    

}