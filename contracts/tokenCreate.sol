// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OwnedToken{
    TokenCreator creator;
    address owner;
    bytes32 public name;
    constructor(bytes32 _name){
        owner = msg.sender;
        creator = TokenCreator(msg.sender);
        name = _name;
    } 

    function changeName(bytes32 newName) public {
        if(msg.sender == address(creator)) name = newName;
    }
    function transfer(address newOwner) public {
        if(msg.sender != owner) return;

        if(creator.isTokenTransferOk(owner,newOwner)){
            owner = newOwner;
        }
    }

}

contract TokenCreator{
    event TokenCreated(bytes32 name, address tokenAddress);

    function createToken(bytes32 name) public returns (OwnedToken tokenAddress){
        tokenAddress = new OwnedToken(name);
        emit TokenCreated(name, address(tokenAddress));
    }

    function changeName(OwnedToken tokenAddress,bytes32 name) public {
        tokenAddress.changeName(name);
    }

    function isTokenTransferOk(address currentOwner, address newOwner)public pure returns (bool ok)
    {
        return keccak256(abi.encodePacked(currentOwner,newOwner))[0] == 0x7f;
    }
}