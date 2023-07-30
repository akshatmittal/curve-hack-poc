// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { IERC20 } from "./IERC20.sol";

interface WETH is IERC20 {
    function deposit() external payable;

    function withdraw(uint wad) external;
}
