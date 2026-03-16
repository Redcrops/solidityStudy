// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract A {
    uint256[] public numbers;
    address[10] private users;
    uint8 users_count;
    function addUser(address _user) external  {
        require(users_count < 10 ,"number of users is limited to 10");
        users[users_count] = _user;
        users_count++;
    }
    function addNumber(uint256 _number) external {
        numbers.push(_number);
    }
}