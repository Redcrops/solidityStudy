
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2;

contract HelloWorldContract {
    address owner;//状态变量
    constructor()
    {
        owner = msg.sender;
    }
    function sayHello() external view returns(string memory)
    {
        if(owner == msg.sender)
        {
            return "hello Daddy";
        }
        string memory greeting = "hello world";//局部变量
        return greeting;
    }
}