// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import './CloneFactory.sol';

contract Factory is CloneFactory{
    Child[] public children;
    address msterContract;
    constructor(address _masterContract){
        msterContract = _masterContract;
    }
    
    function createChild(uint data) external {
        Child child = Child(createClone(msterContract));
        child.init(data);
        children.push(child);
    }

    function getChildren() external view returns(Child[] memory){
        return children;
    }
}

contract Child{
    uint public data;

    function init(uint _data) external {
        data = _data;
    }
}