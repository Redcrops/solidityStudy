// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract B {
     
     function createMemArrays() external view {
         uint256[20] memory numbers;
         numbers[0] = 1;
         numbers[1] = 2;
         
         uint256 users_num = numbers.length;
        //  address[users_num] memory users1; // 错误 :  应该是整数常量或常量表达式

         address[] memory users2 = new address[](users_num);
         users2[0] = msg.sender; // OK
        //  users2.push(msg.sender); // 错误 : member push is not available
         
     }
      
}
