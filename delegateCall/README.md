# DelegateCall 项目说明文档

## 项目概述

本项目演示 Solidity 中合约间调用的模式：`Machine` 合约通过持有 `Storage` 合约地址，委托其进行数据的读写操作。

---

## 合约结构

```
delegateCall/
├── contracts/
│   ├── storage.sol     # 数据存储合约
│   └── machine.sol     # 业务逻辑合约（依赖 Storage）
├── migrations/         # 部署脚本
├── test/
│   └── test.js         # JavaScript 测试文件
└── truffle-config.js   # Truffle 网络配置
```

---

## 合约说明

### Storage.sol

负责存储一个 `uint` 类型的值。

```solidity
contract Storage {
    uint public val;
    constructor(uint v)       // 初始化 val
    function setValue(uint v) // 设置 val
}
```

### Machine.sol

持有 Storage 合约地址，通过它读写数据。

```solidity
contract Machine {
    Storage public s;
    constructor(Storage addr)          // 绑定 Storage 地址
    function saveValue(uint x) → bool  // 调用 s.setValue(x)
    function getValue() → uint         // 调用 s.val()
}
```

**调用链：**

```
外部账户
  → Machine.saveValue(54)
    → Storage.setValue(54)
      → Storage.val = 54
```

---

## 环境配置

### 依赖安装

```bash
npm install --save-dev @openzeppelin/test-helpers chai
```

### Ganache 配置

`truffle-config.js` 中 `development` 网络配置：

| 参数 | 值 |
|---|---|
| host | 127.0.0.1 |
| port | 7545 |
| network_id | 5777 |

启动 Ganache 后端口必须与此一致。

---

## 部署

```bash
# 编译合约
truffle compile

# 部署到本地 Ganache
truffle migrate --network development

# 进入控制台交互
truffle console --network development
```

---

## 测试

### 运行测试

```bash
# 必须指定 --network，否则默认连接 9545 会报错
truffle test --network development
```

### 测试文件说明（test/test.js）

测试文件使用**纯 JavaScript**编写，基于以下技术栈：

| 工具 | 作用 |
|---|---|
| Mocha | 测试框架（`describe` / `it` / `beforeEach`） |
| Chai | 断言库（`expect(...).to.equal(...)`） |
| @openzeppelin/test-helpers | 提供 `BN`（大数）等工具 |
| Web3.js | 与区块链交互（Truffle 自动注入） |

### 测试执行流程

```
truffle test --network development
       ↓
  编译合约（如有变更）
       ↓
  连接 Ganache（7545）
       ↓
  对每个 it() 用例：
    1. beforeEach → 部署新的 Storage & Machine 实例
    2. 执行测试逻辑
    3. 断言结果
       ↓
  输出测试报告
```

### 关键 API

```javascript
// 部署新合约实例
const storage = await StorageContract.new(new BN('0'));

// 发送交易（写操作，消耗 gas，不返回合约返回值）
await machine.saveValue(new BN('54'));

// 读取状态（不消耗 gas，返回合约返回值）
const val = await storage.val();

// 获取写操作的返回值
const ok = await machine.saveValue.call(new BN('54'));
```

### 常见错误

| 错误信息 | 原因 | 解决方法 |
|---|---|---|
| `CONNECTION ERROR: Couldn't connect to node http://127.0.0.1:9545` | 未指定 `--network`，默认连接 9545 | 加上 `--network development` |
| `ReferenceError: BN is not defined` | 未引入 BN | 添加 `const { BN } = require('@openzeppelin/test-helpers')` |
| `Error: Cannot find module '@openzeppelin/test-helpers'` | 未安装依赖 | `npm install --save-dev @openzeppelin/test-helpers` |

---

## 完整测试示例

```javascript
const { BN } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');

const StorageContract = artifacts.require('Storage');
const MachineContract = artifacts.require('Machine');

contract('Machine', (accounts) => {
    const [owner] = accounts;
    let storage, machine;

    beforeEach(async () => {
        storage = await StorageContract.new(new BN('0'));
        machine = await MachineContract.new(storage.address);
    });

    describe('#saveValue()', () => {
        it('should save value to Storage', async () => {
            await machine.saveValue(new BN('54'));
            const result = await storage.val();
            expect(result).to.be.bignumber.equal(new BN('54'));
        });

        it('should return true', async () => {
            const ok = await machine.saveValue.call(new BN('100'));
            expect(ok).to.equal(true);
        });
    });

    describe('#getValue()', () => {
        it('should read value from Storage', async () => {
            await storage.setValue(new BN('99'));
            const result = await machine.getValue();
            expect(result).to.be.bignumber.equal(new BN('99'));
        });
    });
});
```