// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "./PriceConverter.sol";

error notOwner();

contract SimpleToken {

    using PriceConverter for uint256;

    mapping(address => uint256) public tokenBalance;
    uint256 public tokenSupply = 1000000;
    uint256 constant TOKEN_PRICE_USD = 1 * 1e18;
    address immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function buyTokens() public payable {
        uint256 boughtTokens = msg.value.getConversionRateInUsd() / TOKEN_PRICE_USD;
        require(tokenSupply >= boughtTokens, "Not enough tokens remain");
        tokenBalance[msg.sender] += boughtTokens;
        tokenSupply -= boughtTokens;
    }

    function sellTokens(uint256 _amount) public payable {
        require(_amount <= tokenBalance[msg.sender], "Not enough tokens on balance");
        tokenSupply += _amount;
        (bool callSuccess,) = payable(msg.sender).call{value:(_amount*TOKEN_PRICE_USD).getConversionRateInEth()}("");
        require(callSuccess, "Call failed");
    }

    function transfer(address _from, address _to, uint256 _amount) public {
        require(tokenBalance[_from] >= _amount, "Not enough tokens");
        tokenBalance[_from] -= _amount;
        tokenBalance[_to] += _amount;
    }

    function mintTokens(uint256 _amount) public onlyOwner {
        tokenSupply += _amount;
    }

    function burnTokens(uint256 _amount) public onlyOwner {
        require(_amount <= tokenBalance[msg.sender], "Not enough tokens tokens on balance");
        tokenSupply -= _amount;
    }

    modifier onlyOwner {
        if(i_owner != msg.sender) {revert notOwner();}
        _;
    }

}