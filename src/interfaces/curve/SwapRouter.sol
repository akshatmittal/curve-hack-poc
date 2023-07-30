// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.7.0 <0.9.0;

interface SwapRouter {
    // """
    // @notice Perform up to four swaps in a single transaction
    // @dev Routing and swap params must be determined off-chain. This
    //      functionality is designed for gas efficiency over ease-of-use.
    // @param _route Array of [initial token, pool, token, pool, token, ...]
    //               The array is iterated until a pool address of 0x00, then the last
    //               given token is transferred to `_receiver`
    // @param _swap_params Multidimensional array of [i, j, swap type] where i and j are the correct
    //                     values for the n'th pool in `_route`. The swap type should be
    //                     1 for a stableswap `exchange`,
    //                     2 for stableswap `exchange_underlying`,
    //                     3 for a cryptoswap `exchange`,
    //                     4 for a cryptoswap `exchange_underlying`,
    //                     5 for factory metapools with lending base pool `exchange_underlying`,
    //                     6 for factory crypto-meta pools underlying exchange (`exchange` method in zap),
    //                     7-11 for wrapped coin (underlying for lending or fake pool) -> LP token "exchange" (actually `add_liquidity`),
    //                     12-14 for LP token -> wrapped coin (underlying for lending pool) "exchange" (actually `remove_liquidity_one_coin`)
    //                     15 for WETH -> ETH "exchange" (actually deposit/withdraw)
    // @param _amount The amount of `_route[0]` token being sent.
    // @param _expected The minimum amount received after the final swap.
    // @param _pools Array of pools for swaps via zap contracts. This parameter is only needed for
    //               Polygon meta-factories underlying swaps.
    // @param _receiver Address to transfer the final output token to.
    // @return Received amount of the final output token
    // """

    function exchange_multiple(
        address[9] calldata _route,
        uint256[3][4] calldata _swap_params,
        uint256 _amount,
        uint256 _expected,
        address[4] calldata _pools,
        address _receiver
    ) external;
}
