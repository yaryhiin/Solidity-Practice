// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

library MathOperations {

    function add(uint256 _first, uint256 _second) public pure returns (uint256) {
        return _first + _second;
    }

    function substract(uint256 _first, uint256 _second) public pure returns (uint256) {
        return _first - _second;
    }

    function multiply(uint256 _first, uint256 _second) public pure returns (uint256) {
        return _first * _second;
    }

    function divide(uint256 _first, uint256 _second) public pure returns (uint256) {
        return _first / _second;
    }

}