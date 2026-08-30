// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {MemeCoin} from "../src/Memecoin.sol";

contract MemeCoinTest is Test{
    MemeCoin token; 

    address alice = address(0xA11CE);
    address bob = address(0xB0B);

    function setUp() public {
        token = new MemeCoin(); 
    }

    function testInitiaSupplyBelongsToDeployer() public {
        assertEq (token.balances(address(this)),1_000_000 );   
    }

    function testTransfer() public {
        token.transfer(alice, 100);

        assertEq(token.balances(alice), 100);
        assertEq(token.balances(address(this)), 999_900);
    }

}