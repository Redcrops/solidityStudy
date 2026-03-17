// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DefaultVisibility {
    // 状态变量默认 internal
    uint256 defaultStateVar; // 等价于 uint256 internal defaultStateVar;
    
    // 常量默认 internal
    uint256 public constant PUBLIC_CONST = 1; // 显式public，生成getter
    uint256 constant DEFAULT_CONST = 2; // 等价于 internal constant DEFAULT_CONST
    
    // 构造函数默认 public
    constructor() { // 等价于 constructor() public {}
        defaultStateVar = 100;
    }

    // 普通函数默认 public + nonpayable
    function defaultFunction() { // 等价于 function defaultFunction() public nonpayable {}
        defaultStateVar += 1; // 可修改状态
        // msg.value = 1 ether; ❶ 调用时传ETH会回滚（因为默认nonpayable）
    }

    // 显式声明view（仍默认public）
    function viewFunction() view returns (uint256) { // 等价于 public view
        return defaultStateVar; // 仅读取，不能修改
    }

    // 显式声明pure（仍默认public）
    function pureFunction(uint256 a) pure returns (uint256) { // 等价于 public pure
        return a + 1; // 不读写状态
    }

    // 回退函数必须显式声明external
    fallback() external payable { // 无默认，必须加external，payable可选
        defaultStateVar += msg.value;
    }
}