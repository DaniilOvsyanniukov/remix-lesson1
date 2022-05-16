// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import './token/HouseToken.sol';

contract HouseRegistry {
    uint256 digits = 5;
    uint256 modulus = 10**digits;
    uint256 cooldownTime = 1 days;
    uint256 countOfHouses = 1;
    uint256 private ownerAddCooldown;

    modifier canOwnerAdd() {
        require(ownerAddCooldown <= block.timestamp, 'The owner cannot yet add a new home');
        _;
    }

    event AddNewHouse(
        uint256 houseId,
        address _sellerAddress,
        uint256 price,
        uint256 priceDai,
        string houseAddress
    );

    uint256[] private houseIndex;
    mapping(uint256 => address) public houses;

    function _ownerCooldown(uint256 _newTime) internal {
        ownerAddCooldown = _newTime;
    }

    function listHouse(
        uint256 _price,
        uint256 _priceDai,
        uint256 _area,
        address _sellerAddress,
        string memory _houseAddress
    ) public returns (uint256) {
        require(_price * _area > 0, 'value cannot be null');
        uint256 houseId = _generateHouseId(_sellerAddress, _area, _houseAddress);
        require(finHouseId(houseId), 'this houseId already exists');
        HouseToken house = new HouseToken(
            houseId,
            countOfHouses,
            _price,
            _priceDai,
            _area,
            _sellerAddress,
            _sellerAddress,
            _houseAddress,
            false
        );
        houses[houseId] = address(house);
        _ownerCooldown(block.timestamp + cooldownTime);
        houseIndex.push(houseId);
        countOfHouses++;
        emit AddNewHouse(houseId, _sellerAddress, _price, _priceDai, _houseAddress);
        return houseId;
    }

    function finHouseId(uint256 houseId) private view returns (bool) {
        bool result = true;
        for (uint256 i = 0; i < houseIndex.length; i++) {
            if (houseIndex[i] == houseId) {
                result = false;
            }
        }
        return result;
    }

    function delistHouse(uint256 houseId) public view returns (string memory) {
        require(houses[houseId] == msg.sender, 'You do not have access to delete this house');
        HouseToken(houses[houseId]).delistHouse();
        return 'delist was successful';
    }

    function getCheapHouseIds(uint256 cost) external view returns (uint256[] memory) {
        uint256 count = 0;
        for (uint256 i = 0; i < houseIndex.length; i++) {
            if (HouseToken(houses[houseIndex[i]]).getPrice() < cost) {
                count++;
            }
        }
        uint256[] memory filteredHouses = new uint256[](count);
        for (uint256 i = 0; i < houseIndex.length; i++) {
            if (HouseToken(houses[houseIndex[i]]).getPrice() < cost) {
                filteredHouses[i] = HouseToken(houses[houseIndex[i]]).getId();
            }
        }
        return filteredHouses;
    }

    function _generateHouseId(
        address _sellerAddress,
        uint256 _area,
        string memory _houseAddress
    ) private view returns (uint256) {
        uint256 houseId = uint256(
            keccak256(abi.encodePacked(_sellerAddress, _area, _houseAddress))
        );
        return houseId % modulus;
    }
}
