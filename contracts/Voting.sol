// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

error alreadyVoted();
error alreadyCandidate();

contract Voting {
    address[] public candidates;
    mapping(address => uint) public votes;
    address[] public voters;

    function addCandidate() public {
        for (uint256 i = 0; i < candidates.length; i++) {
            if (msg.sender == candidates[i]) {
                revert alreadyCandidate();
            } 
        }
        candidates.push(msg.sender);
    }

    function Vote(address _candidate) public {
        bool notCandidate;
        for (uint256 i = 0; i < candidates.length; i++) {
            if (_candidate == candidates[i]) {
                notCandidate = true;
            } 
        }
        require(notCandidate, "There is no such candidate");
        for (uint256 i = 0; i < voters.length; i++) {
            if (msg.sender == voters[i]) {
                revert alreadyVoted();
            } 
        }
        votes[_candidate]++;
        voters.push(msg.sender);
    }

    function getVotes(address _candidate) public view returns (uint256) {
        return votes[_candidate];
    }
}