// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

function selectWinner() external {
    require(msg.sender == owner, "this function is restricted to the owner)");
    }

modifier onlyOwner() {
    require(msg.sender == owner, "this function is restricted to the owner");
      _; // will be replaced by the code of the function
}
