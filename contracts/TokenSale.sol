// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

error notOwner();

contract TokenSale {
    uint256 constant tokenPrice = 30000;
    uint256 tokenBalance = 1000000;
    mapping(address => uint256) public balances;
    address immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

   function buyTokens() public payable {
        uint256 boughtTokens = (msg.value) / tokenPrice;
        require(boughtTokens <= tokenBalance, "Not enough tokens available");
        tokenBalance -= boughtTokens;
        balances[msg.sender] += boughtTokens;
    }

    function sellTokens(uint256 _amount) public payable {
        require (_amount <= balances[msg.sender]);
        require (_amount*tokenPrice < address(this).balance);
        tokenBalance += _amount;
        balances[msg.sender] -= _amount;
        (bool callSuccess,) = payable(msg.sender).call{value:_amount*tokenPrice}("");
        require(callSuccess, "Call failed");
    }

    function getTokenBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    function withdrawEth() public payable onlyOwner {
        require (address(this).balance > 0);
        (bool callSuccess,) = payable(msg.sender).call{value:address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    modifier onlyOwner {
        if (msg.sender != i_owner) {revert notOwner();}
        _;
    }

}