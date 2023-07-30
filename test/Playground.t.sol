// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

import { CurveHackFlash } from "../src/CurveHackFlash.sol";

contract PlaygroundTest is Test {
    CurveHackFlash curveHackFlash;

    function setUp() public {
        vm.createSelectFork("https://rpc.ankr.com/eth", 17807829);

        curveHackFlash = new CurveHackFlash();
    }

    function testAttempt() public {
        curveHackFlash.makeFlashLoan{ gas: 30_000_000 }();
    }
}
