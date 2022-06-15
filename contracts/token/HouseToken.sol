// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)

pragma solidity ^0.8.2;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import './IHouseToken.sol';

contract HouseToken is ERC721 {
    uint256 public id;
    uint256 public serialNumber;
    uint256 public price;
    uint256 public priceDai;
    uint256 public area;
    address public sellerAddress;
    address public buyerAddress;
    string public houseAddress;
    bool public isdelistedHouse;

    constructor(
        uint256 id_,
        uint256 serialNumber_,
        uint256 price_,
        uint256 priceDai_,
        uint256 area_,
        address sellerAddress_,
        address buyerAddress_,
        string memory houseAddress_,
        bool isdelistedHouse_
    ) ERC721('HouseToken', 'HT') {
        id = id_;
        serialNumber = serialNumber_;
        price = price_;
        priceDai = priceDai_;
        area = area_;
        sellerAddress = sellerAddress_;
        buyerAddress = buyerAddress_;
        houseAddress = houseAddress_;
        isdelistedHouse = isdelistedHouse_;
    }

    function changeBuyerAddress(address _buyerAddress) external {
        buyerAddress = _buyerAddress;
    }

    function delistHouse() external {
        isdelistedHouse = true;
    }
}
