// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract HouseRegistry {

    uint digits = 5;
    uint modulus = 10 ** digits;
    struct House{
        uint id;
        uint price;
        uint area;
        address sellerAddress;
        string houseAddress;
    }

    event AddNewHouse (uint houseId, address _sellerAddress, uint price, string houseAddress);
    mapping(uint => House) public houses;

    function listHouse (uint _price, uint _area, address _sellerAddress, string memory _houseAddress) public returns (uint) {
        require(_price * _area > 0, "value cannot be null");
        uint houseId = _generateHouseId(_sellerAddress, _area, _houseAddress);
        require(houseId != houses[houseId].id, "this houseId already exists");
        houses[houseId] = House(houseId, _price, _area, _sellerAddress, _houseAddress);
        emit AddNewHouse(houseId, _sellerAddress, _price, _houseAddress);
        return houseId;
    }

    function _generateHouseId(address _sellerAddress, uint _area, string memory _houseAddress) private view returns(uint){
        uint houseId = uint(keccak256(abi.encodePacked(_sellerAddress, _area, _houseAddress)));
        return houseId % modulus;
    }

}