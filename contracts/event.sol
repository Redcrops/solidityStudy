// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract EventExample{
    event DataStored(uint256 val1,  uint256 indexed val2);
    uint256 val1;
    uint256 val2;
    function storeData(uint256 _val1,uint256 _val2) external {
        val1 = _val1;
        val2 = _val2;
        emit DataStored(val1,val2);
    }
}