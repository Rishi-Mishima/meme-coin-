// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

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
        assertEq(token.balanceOf(address(this)), token.totalSupply);
    }

    function testTransfer() public {
        token.transfer(alice, 100);

        assertEq(token.balanceOf(alice), 100);
        assertEq(token.balanceOf(address(this)), token.totalSupply() - 100);
    }

    function testTransferFailsWhenBalanceNotEnough() public {
        uint256 senderBalanceBefore = token.balanceOf(address(this));

        vm.expectRevert("BALANCE NOT ENOUGH");

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

    // 授权余额不足的错误test
    function testTransferFromFailsWhenAllowanceNotEnough() public {
        token.transfer(alice, 1000);

        vm.prank(alice);
        token.approve(bob, 100);

        vm.prank(bob);
        vm.expectRevert("ALLOWANCE NOT ENOUGH");

        token.transferFrom(alice, charlie, 200);
    }

    // 测试收款地址不能是零地址
    function testTransferFailsWhenToIsZeroAddress() public {
        vm.expectRevert("TRANSFER TO ZERO ADDRESS");

        token.transfer(address(0), 100);
    }

    // 测试不能把账户授权给零地址
    function testApproveFailsWhenSpenderIsZeroAddress() public {
        vm.expectRevert("APPROVE TO ZERO ADDRESS");

        token.approve(address(0), 100);
    }
}
