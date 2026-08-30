// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract MemeCoin {
    // 写出ERC声明
    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

    string public name = "Miyuki meme coin";
    string public symbol = "MIYU";

    uint256 public totalSupply = 1_000_000 * 10 ** 18;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    constructor() {
        _balances[msg.sender] = totalSupply;
    }

    // 实现ERC-20标准函数
    // account 是address里有多少钱, amount是转的钱
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        _transfer(msg.sender, to, amount);

        return true;
    }

    // spender 接受者 : _allowances[address(this)][bob] = 500;
    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);

        return true;
    }

    // 查询函数
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        uint256 currentAllowance = _allowances[from][msg.sender];

        require(currentAllowance >= amount, "ALLOWANCE NOT ENOUGH");

        _approve(from, msg.sender, currentAllowance - amount);

        _transfer(from, to, amount);

        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0), "TRANSFER FROM ZERO ADDRESS");
        require(to != address(0), "TRANSFER TO ZERO ADDRESS");
        require(_balances[from] >= amount, "BALANCE NOT ENOUGH");

        _balances[from] -= amount;
        _balances[to] += amount;

        emit Transfer(from, to, amount);
    }

    // 重构approve
    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "APPROVE FROM ZERO ADDRESS");
        require(spender != address(0), "APPROVE TO ZERO ADDRESS");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}
