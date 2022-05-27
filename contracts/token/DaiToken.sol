// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.1;

// import './ERC20.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract DaiToken is ERC20 {
    constructor() ERC20('Dai', 'D') {
        uint256 n = 100000000;
        _mint(msg.sender, n);
    }
}
