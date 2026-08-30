// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.24;

contract Memecoin{
    string public name = "Miyuki meme coin"; 
    string public symbol = "MIYU"; 

    uint256 public totalSupply = 1_000_000;

    mapping (addres => uint256) public balances; 

    constructor() {
        balances[msg.sender] = totalSupply;
    }

    function transfer(address to, uint256 amount) public {
        require(balances(msg.sender) >= amount, "NOT ENOUGHT AMOUNT");

        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
}