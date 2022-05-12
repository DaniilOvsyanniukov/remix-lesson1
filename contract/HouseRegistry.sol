// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./token/HouseToken.sol";
import "./token/IHouseToken.sol";


contract HouseRegistry is HouseToken { 

    uint digits = 5;
    uint modulus = 10 ** digits;
    uint cooldownTime = 1 days;
    uint countOfHouses = 1;
    uint private ownerAddCooldown;

    uint id;
    uint serialNumber;
    uint price;
    uint priceDai;
    uint area;
    address sellerAddress;
    address buyerAddress;
    string houseAddress;
    bool isdelistedHouse;

    constructor () HouseToken (id, serialNumber, price, priceDai, area, sellerAddress, buyerAddress, houseAddress, isdelistedHouse){
    }

    modifier canOwnerAdd() {
        require(ownerAddCooldown <= block.timestamp, "The owner cannot yet add a new home");
        _;
    }

    event AddNewHouse (uint houseId, address _sellerAddress, uint price, uint priceDai, string houseAddress);
    
    uint[] private houseIndex;
    mapping(uint => address) public houses;
 
    function _ownerCooldown(uint _newTime) internal {
        ownerAddCooldown = _newTime;
    }

    function listHouse (uint _price, uint _priceDai, uint _area, address _sellerAddress, string memory _houseAddress) public returns (uint) {
        require(_price * _area > 0, "value cannot be null");
        uint houseId = _generateHouseId(_sellerAddress, _area, _houseAddress);
        // require(getTokenId(houseId) > 0, "this houseId already exists");
        HouseToken house = new HouseToken(houseId, countOfHouses, _price, _priceDai, _area, _sellerAddress, _sellerAddress, _houseAddress, false);
        houses[houseId] = address(house);
         _ownerCooldown(block.timestamp + cooldownTime);
        houseIndex.push(houseId);
        countOfHouses++;
        emit AddNewHouse(houseId, _sellerAddress, _price, _priceDai, _houseAddress);
        return houseId;

    }

    function getTokenId (uint houseId) public view returns (uint){
        return HouseToken(houses[houseId])._getId();
    }

    function delistHouse(uint houseId) public view returns (string memory){
        require(houses[houseId] == msg.sender, "You do not have access to delete this house");
        HouseToken(houses[houseId])._delistHouse;
        return "delist was successful";
    }

    function getCheapHouseIds(uint cost) external view returns (uint[]memory){
        uint count = 0;
        for(uint i = 0; i < houseIndex.length; i++){
            if(HouseToken(houses[houseIndex[i]])._getPrice() < cost){
                count++;
            }
        }
        uint[] memory filteredHouses = new uint[](count);
        for(uint i = 0; i < houseIndex.length; i++){
            if(HouseToken(houses[houseIndex[i]])._getPrice() < cost){
                filteredHouses[i] = HouseToken(houses[houseIndex[i]])._getId();
            }
        }
        return filteredHouses;
    }

    function _generateHouseId(address _sellerAddress, uint _area, string memory _houseAddress) private view returns(uint){
        uint houseId = uint(keccak256(abi.encodePacked(_sellerAddress, _area, _houseAddress)));
        return houseId % modulus;
    }

}