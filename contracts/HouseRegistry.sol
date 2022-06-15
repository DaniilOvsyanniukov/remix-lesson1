// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.2;

import './token/IHouseToken.sol';
import './IHouseFactory.sol';
import '@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol';

contract HouseRegistry is Initializable {
    function initialize(address _houseFactoryAddress) public initializer {
        houseFactoryAddress = _houseFactoryAddress;
        cooldownTime = 1 days;
    }

    address public houseFactoryAddress;
    uint256 public cooldownTime;
    uint256 public countOfHouses;

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

    uint256[] public houseIndex;
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
        houses[houseId] = IHouseFactory(houseFactoryAddress).createHouse(
            houseId,
            countOfHouses,
            _price,
            _priceDai,
            _area,
            _sellerAddress,
            _sellerAddress,
            _houseAddress
        );
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
            IHouseToken(houses[houseId]).sellerAddress() == msg.sender,
            'You do not have access'
        );
        IHouseToken(houses[houseId]).delistHouse();
        string memory message = 'delisted was successful';
        emit IsDelistedHouse(message);
        return message;
    }

    function getCheapHouseIds(uint256 cost) external view returns (uint256[] memory) {
        uint256 count = 0;
        for (uint256 i = 0; i < houseIndex.length; i++) {
            if (IHouseToken(houses[houseIndex[i]]).price() <= cost) {
                count++;
            }
        }
        uint256[] memory filteredHouses = new uint256[](count);
        for (uint256 i = 0; i < houseIndex.length; i++) {
            if (IHouseToken(houses[houseIndex[i]]).price() <= cost) {
                filteredHouses[i] = IHouseToken(houses[houseIndex[i]]).id();
            }
        }
        return filteredHouses;
    }

    function _generateHouseId(
        address _sellerAddress,
        uint256 _area,
        string memory _houseAddress
    ) internal pure returns (uint256) {
        uint256 digits = 5;
        uint256 modulus = 10**digits;
        uint256 houseId = uint256(
            keccak256(abi.encodePacked(_sellerAddress, _area, _houseAddress))
        );
        return houseId % modulus;
    }
}
