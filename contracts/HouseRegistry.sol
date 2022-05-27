// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.1;

import './token/HouseToken.sol';

contract HouseRegistry {
    uint256 private digits = 5;
    uint256 private modulus = 10**digits;
    uint256 private cooldownTime = 1 days;
    uint256 private countOfHouses = 1;

    modifier canOwnerAdd() {
        require(cooldown[msg.sender] <= block.timestamp, 'The owner cannot add a new home');
        _;
    }

    event AddNewHouse(
        uint256 houseId,
        address _sellerAddress,
        uint256 price,
        uint256 priceDai,
        string houseAddress
    );

    event IsDelistedHouse(string message);

    uint256[] private houseIndex;
    mapping(uint256 => address) public houses;

    mapping(address => uint256) public cooldown;

    function _ownerCooldown(uint256 _newTime, address _address) internal {
        cooldown[_address] = _newTime;
    }

    function listHouse(
        uint256 _price,
        uint256 _priceDai,
        uint256 _area,
        address _sellerAddress,
        string memory _houseAddress
    ) public canOwnerAdd returns (uint256) {
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
        _ownerCooldown(block.timestamp + cooldownTime, msg.sender);
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

    function delistHouse(uint256 houseId) public returns (string memory) {
        require(
            HouseToken(houses[houseId]).sellerAddress() == msg.sender,
            'You do not have access'
        );
        HouseToken(houses[houseId]).delistHouse();
        string memory message = 'delisted was successful';
        emit IsDelistedHouse(message);
        return message;
    }

    function getCheapHouseIds(uint256 cost) external view returns (uint256[] memory) {
        uint256 count = 0;
        for (uint256 i = 0; i < houseIndex.length; i++) {
            if (HouseToken(houses[houseIndex[i]]).price() < cost) {
                count++;
            }
        }
        uint256[] memory filteredHouses = new uint256[](count);
        for (uint256 i = 0; i < houseIndex.length; i++) {
            if (HouseToken(houses[houseIndex[i]]).price() < cost) {
                filteredHouses[i] = HouseToken(houses[houseIndex[i]]).id();
            }
        }
        return filteredHouses;
    }

    function _generateHouseId(
        address _sellerAddress,
        uint256 _area,
        string memory _houseAddress
    ) internal view returns (uint256) {
        uint256 houseId = uint256(
            keccak256(abi.encodePacked(_sellerAddress, _area, _houseAddress))
        );
        return houseId % modulus;
    }
}
