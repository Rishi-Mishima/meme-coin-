// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {MemeCoin} from "../src/Memecoin.sol";

contract MemeCoinTest is Test {
    event Transfer(address indexed from, address indexed to, uint256 value);

    MemeCoin token;

    address alice = address(0xA11CE);
    address bob = address(0xB0B);

    function setUp() public {
        token = new MemeCoin();
    }

    function testInitiaSupplyBelongsToDeployer() public {
        assertEq(token.balancesOf(address(this)), 1_000_000);
    }

    function testTransfer() public {
        token.transfer(alice, 100);

        assertEq(token.balancesOf(alice), 100);
        assertEq(token.balancesOf(address(this)), 999_900);
    }

    function testTransferFailsWhenBalanceNotEnough() public {
        uint256 senderBalanceBefore = token.balancesOf(address(this));
        uint256 bobBalanceBefore = token.balancesOf(bob);

        vm.expectRevert("NOT ENOUGH AMOUNT");

        token.transfer(bob, senderBalanceBefore + 1);

        assertEq(token.balancesOf(address(this)), senderBalanceBefore);

        assertEq(token.balancesOf(bob), bobBalanceBefore);
    }

    function testTransferReturnsTrue() public {
        bool success = token.transfer(bob, 100);
        assertTrue(success);
    }

    function testTransferEmitsEvent() public {
        vm.expectEmit(true, true, false, true);

        emit Transfer(address(this), bob, 100);

        token.transfer(bob, 100);
    }
}
