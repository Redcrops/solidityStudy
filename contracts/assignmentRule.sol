// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract DataLocalionTest
{
    uint[] stateVar = [1,4,5];
    function foo() public {
        //case 1 : 从存储中加载到内存
        uint[] memory y = stateVar; //复制statebar 到 y

        //case 2 : from memory to storage
        y[0] = 12;
        y[1] = 20;
        y[2] = 24;

        stateVar = y; //copy the content of y to stateVar
        
        uint[] memory tmpY = y;
        tmpY[0] = 99;
        //case 3: from storage to storage
        uint[] storage z = stateVar;//z is a pointer to stateVar

        z[0] = 38;
        z[1] = 89;
        z[2] = 72;

    }
}