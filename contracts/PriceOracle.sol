// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceOracle {

    function getAssetPrice(address _contract) public view returns(uint256) {
        AggregatorV3Interface asset = AggregatorV3Interface(_contract);
        (,int price,,,) = asset.latestRoundData();
        uint8 decimals = asset.decimals();
        uint256 priceWithDecimals = uint256(price) / 10**(decimals);
        return priceWithDecimals;
    }

}