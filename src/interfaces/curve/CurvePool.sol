// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

interface CurvePool {
    // v2 meta
    function exchange_underlying(int128 i, int128 j, uint256 dx, uint256 min_dy) external;

    // v1
    function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external payable returns (uint256);

    function exchange(uint256 i, uint256 j, uint256 dx, uint256 min_dy, bool use_eth) external payable;

    // Balances
    function balances(uint256 id) external view returns (uint256);

    function add_liquidity(uint256[2] memory amounts, uint256 min_mint_amount) external payable returns (uint256);

    function add_liquidity(uint256[2] memory amounts, uint256 min_mint_amount, bool use_eth)
        external
        payable
        returns (uint256);

    function remove_liquidity(uint256 _amount, uint256[2] memory _min_amounts, bool use_eth) external;

    function remove_liquidity(uint256 _amount, uint256[2] memory _min_amounts) external;

    function remove_liquidity_one_coin(uint256 _token_amount, int128 i, uint256 _min_amount) external;

    function remove_liquidity_one_coin(uint256 _token_amount, uint256 i, uint256 _min_amount, bool use_eth) external;
}
