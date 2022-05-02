// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract HouseRegistry {

    uint digits = 5;
    uint modulus = 10 ** digits;
    uint cooldownTime = 1 seconds;
    uint countOfHouses = 1;
    uint private ownerAddCooldown;

    struct House{
        uint id;
        uint serialNumber;
        uint price;
        uint area;
        address sellerAddress;
        string houseAddress;
        bool isdelistedHouse;
    }

    modifier canOwnerAdd() {
        require(ownerAddCooldown <= block.timestamp, "The owner cannot yet add a new home");
        _;
    }

    event AddNewHouse (uint houseId, address _sellerAddress, uint price, string houseAddress);
 
    mapping(uint => House) public houses;

    function _ownerCooldown(uint _newTime) internal {
        ownerAddCooldown = _newTime;
    }

    function listHouse (uint _price, uint _area, address _sellerAddress, string memory _houseAddress) public returns (uint) {
        require(_price * _area > 0, "value cannot be null");
        uint houseId = _generateHouseId(_sellerAddress, _area, _houseAddress);
        require(houseId != houses[houseId].id, "this houseId already exists");
        houses[houseId] = House(houseId, countOfHouses, _price, _area, _sellerAddress, _houseAddress, false);
        _ownerCooldown(block.timestamp + cooldownTime);
        countOfHouses++;
        emit AddNewHouse(houseId, _sellerAddress, _price, _houseAddress);
        return houseId;
    }

        function delistHouse(uint houseId) public returns (string memory){
        require(houses[houseId].sellerAddress == msg.sender, "You do not have access to delete this house");
        houses[houseId].isdelistedHouse = true;
        return "delist was successful";
    }

        function getCheapHouseIds(uint cost) external payable returns (uint[] memory){
            uint[] memory filteredHouses;
            uint count = 0;
        for(uint i = 1; i <= countOfHouses; i++){
            if(houses[i].price <= cost){
                filteredHouses[count] = houses[i].id;
                count++;
            }
        }
        return filteredHouses;
    }

    function _generateHouseId(address _sellerAddress, uint _area, string memory _houseAddress) private view returns(uint){
        uint houseId = uint(keccak256(abi.encodePacked(_sellerAddress, _area, _houseAddress)));
        return houseId % modulus;
    }



}