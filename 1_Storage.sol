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

    event AddNewHouse (uint houseId, address sellerAddress, uint price, string houseAddress);

    House[] public houses;

    function listHouse (uint _price, uint _area, address _sellerAddress, string memory _houseAddress) public returns (uint) {
        uint houseId = _generateHouseId(_sellerAddress, _area, _houseAddress);
        houses.push(House(houseId, _price, _area, _sellerAddress, _houseAddress));
        emit AddNewHouse(houseId, _sellerAddress, _price, _houseAddress);
        return houseId;

    }

    function _generateHouseId(address _sellerAddress, uint _area, string memory _houseAddress) private view returns(uint){
        uint houseId = uint(keccak256(abi.encodePacked(_sellerAddress, _area, _houseAddress)));
        return houseId % modulus;
    }

}