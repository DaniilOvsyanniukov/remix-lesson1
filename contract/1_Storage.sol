// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */

contract HouseRegistry {

    uint digits = 5;
    uint modulus = 10 ** digits;
    struct House{
        uint id;
        uint price;
        uint area;
        string sellerAddress;
        string houseAddress;
    }

    event AddNewHouse (uint houseId, string sellerAddress, uint price, string houseAddress);

    House[] public houses;

    function _generateHouseId(string memory _sellerAddress, uint _area, string memory _houseAddress) private view returns(uint){
        uint houseId = uint(keccak256(abi.encodePacked(_sellerAddress, _area, _houseAddress)));
        return houseId % modulus;
    }

    function listHouse (uint _price, uint _area, string memory _sellerAddress, string memory _houseAddress) public returns (uint) {
        uint houseId = _generateHouseId(_sellerAddress, _area, _houseAddress);
        houses.push(House(houseId, _price, _area, _sellerAddress, _houseAddress));
        emit AddNewHouse(houseId, _sellerAddress, _price, _houseAddress);
        return houseId;

    }

}