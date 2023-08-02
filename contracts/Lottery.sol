// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

error notOwner();

contract Lottery {
    uint256 constant MINIMUM_ETH = 30000;
    mapping(address => uint256) contributions;
    address[] participants;
    address immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function joinLottery() public payable {
        require(msg.value > MINIMUM_ETH, "Not enough Ethereum sent");
        contributions[msg.sender] += msg.value;
        participants.push(msg.sender);
    }

    function determineWinner() public checkOwner {
        require(participants.length > 0, "No participants in the lottery");
        uint256 randomNumber = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp)));
        uint256 winnerIndex = randomNumber % participants.length;
        address winner = participants[winnerIndex];
        payPrize(winner);
    }

    function payPrize(address _winner) public payable checkOwner {
        (bool callSuccess,) = payable(_winner).call{value:address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    function withdraw() public payable checkOwner {
        (bool callSuccess,) = payable(msg.sender).call{value:address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    modifier checkOwner {
        if (msg.sender != i_owner) {revert notOwner();}
        _;
    }
}