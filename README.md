# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a Hardhat Ignition module that deploys that contract.


## Reference

[代码案例](https://github.com/LazyDreamingDog/oracleDemo/tree/main/contracts)

[中文翻译版](https://learnblockchain.cn/docs/hardhat/getting-started/)

[官方文档](https://hardhat.org/hardhat-runner/docs/getting-started)

## Demo

Compile contracts:对于contract目录下的文件进行

```shell
npx hardhat compile 
```

Test contracts：编译完成的合约会在test文件夹生成js文件

```shell
npx hardhat test  [testFile]
```

Deploy contracts

```shell
# 搭建私链,单独起一个进程
npx hardhat node
# 部署合约
npx hardhat ignition deploy ./ignition/modules/Lock.js --network localhost 
```

## Dependency

| Tool    | Version |
| - | - |
| nodejs  | v18.20.5  |
| npm  | 10.8.2   |
