// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract MemeCoin {
    // 写出ERC声明
    event Transfer(address indexed from, address indexed to, uint256 value);

    string public name = "Miyuki meme coin";
    string public symbol = "MIYU";

    uint256 public totalSupply = 1_000_000;

    mapping(address => uint256) private _balances;

    constructor() {
        _balances[msg.sender] = totalSupply;
    }

    // 实现ERC-20标准函数
    // account 是address里有多少钱, amount是转的钱
    function balancesOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        require(_balances[msg.sender] >= amount, "NOT ENOUGH AMOUNT");

        _balances[msg.sender] -= amount;
        _balances[to] += amount;

        // 记录一条链上日志：谁给谁转了多少币。
        emit Transfer(msg.sender, to, amount);

        return true;
    }
}
