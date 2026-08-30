// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.24;

contract MemeCoin{
    string public name = "Miyuki meme coin"; 
    string public symbol = "MIYU"; 

    uint256 public totalSupply = 1_000_000;

    mapping (address => uint256) public balances; 

    constructor() {
        balances[msg.sender] = totalSupply;
    }

    function transfer(address to, uint256 amount) public {
       require(balances[msg.sender] >= amount, "NOT ENOUGH AMOUNT");

        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
}