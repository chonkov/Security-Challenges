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

        assertEq(tokenBankChallenge.balanceOf(player), 500000e18);
        assertEq(tokenBankChallenge.balanceOf(player), tokenBankChallenge.balanceOf(address(this)));

        tokenBankAttacker.attack();

        assertEq(tokenBankChallenge.balanceOf(player), 500000e18);
        assertEq(tokenBankChallenge.balanceOf(address(this)), 500000e18);
        assertEq(tokenBankChallenge.balanceOf(address(tokenBankAttacker)), 0);

        _checkSolved();
    }

    function _checkSolved() internal {
        assertTrue(tokenBankChallenge.isComplete(), "Challenge Incomplete");
    }
}
