
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;
contract Storage {
    uint public val;
    constructor(uint v) public {
        val = v;
    }
    
    function setValue(uint v) public {
        val = v;
    }
}