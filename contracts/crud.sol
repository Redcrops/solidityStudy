// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crud{
    struct User{
        uint256 id;
        string name;
    }
    User[] public userList;
    uint256 public nextId = 1;
    
    function createNewUser(string memory name) public 
    {
        User memory newUser = User({
            id:nextId,
            name:name
        });
        userList.push(newUser);
        nextId++;
    }
    function deleteUser(uint256 id) public {
        uint256 idx = find(id);
        delete userList[idx];
    }   
    function find(uint256 id) private view returns(uint256){
        for(uint256 i=0; i<userList.length; i++)
        {
            if(userList[i].id == id) return i;
        }
        revert("user not found");
    }
}