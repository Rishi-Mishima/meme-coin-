// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {MemeCoin} from "../src/Memecoin.sol";

contract MemeCoinTest is Test {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    MemeCoin token;

    address alice = address(0xA11CE);
    address bob = address(0xB0B);
    address charlie = address(0xCA11);

    function setUp() public {
        token = new MemeCoin();
    }

    function testInitialSupplyBelongsToDeployer() public {
        assertEq(token.balanceOf(address(this)), 1_000_000);
    }

    function testTransfer() public {
        token.transfer(alice, 100);

        assertEq(token.balanceOf(alice), 100);
        assertEq(token.balanceOf(address(this)), 999_900);
    }

    function testTransferFailsWhenBalanceNotEnough() public {
        uint256 senderBalanceBefore = token.balanceOf(address(this));

        vm.expectRevert("NOT ENOUGH AMOUNT");

        token.transfer(bob, senderBalanceBefore + 1);
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

    function testApprove() public {
        bool success = token.approve(bob, 500);

        assertTrue(success);
        assertEq(token.allowance(address(this), bob), 500);
    }

    function testApproveEmitsEvent() public {
        vm.expectEmit(true, true, false, true);

        emit Approval(address(this), bob, 500);

        token.approve(bob, 500);
    }

    function testTransferFrom() public {
        // 给 Alice 1000 个币
        token.transfer(alice, 1000);

        // Alice 授权 Bob 500
        vm.prank(alice);
        token.approve(bob, 500);

        // Bob 使用 Alice 的授权，转 200 给 Charlie
        vm.prank(bob);
        bool success = token.transferFrom(alice, charlie, 200);

        assertTrue(success);

        assertEq(token.balanceOf(alice), 800);
        assertEq(token.balanceOf(charlie), 200);

        assertEq(token.allowance(alice, bob), 300);
    }

    function testTransferFromFailsWhenAllowanceNotEnough() public {
        token.transfer(alice, 1000);

        vm.prank(alice);
        token.approve(bob, 100);

        vm.prank(bob);
        vm.expectRevert("ALLOWANCE NOT ENOUGH");

        token.transferFrom(alice, charlie, 200);
    }
}
