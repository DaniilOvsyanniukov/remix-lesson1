// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)

pragma solidity ^0.8.0;

import "./ERC721.sol";
import "./IHouseToken.sol";

contract HouseToken is ERC721, IHouseToken {

    uint _id;
    uint _serialNumber;
    uint _price;
    uint _priceDai;
    uint _area;
    address _sellerAddress;
    address _buyerAddress;
    string _houseAddress;
    bool _isdelistedHouse;

    constructor(uint id_, uint serialNumber_, uint price_, uint priceDai_, uint area_, address sellerAddress_, address buyerAddress_, string  memory houseAddress_, bool isdelistedHouse_) ERC721("HouseToken", "HT") {
       _id=id_;
       _serialNumber=serialNumber_;
       _price=price_;
       _priceDai=priceDai_;
       _area=area_;
       _sellerAddress=sellerAddress_;
       _buyerAddress=buyerAddress_;
       _houseAddress=houseAddress_;
       _isdelistedHouse=isdelistedHouse_;
    }

    function _changeBuyerAddress (address buyerAddress) external override {
        _buyerAddress = buyerAddress;
    }

    function _delistHouse () external override {
       _isdelistedHouse = true;
    }
    function _getPrice() external view override returns(uint){
        return _price;
    }
    function _getId() external view override returns(uint){
        return _id;
    }  
    function _getSellerAddress() external view  override returns(address){
        return _sellerAddress;
    }

    

}