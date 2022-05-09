// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)

pragma solidity ^0.8.0;

import "./IERC721.sol";

interface HouseToken is IERC721 {

    function addHouse(uint _houseId, uint _serialNumber, uint _price, uint _priceDai, uint _area, address _sellerAddress, string memory _houseAddress) external;

    function setDelistHouse(uint _houseId) external;

    function getHouseInfo(uint _houseId) external;

    function setbuyerAddress(uint _houseId, address _buyerAddress ) external;

    event AddNewTokenHouse(uint _houseId, uint _serialNumber, uint _price, uint _priceDai, string _houseAddress);

    event GetHouseTokenInfo(uint _houseId, uint _serialNumber, uint _price, uint _priceDai, uint _area, address _sellerAddress, string _houseAddress);
    
}