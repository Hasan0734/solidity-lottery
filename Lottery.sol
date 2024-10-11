// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 < 0.9.0;

 contract Lottery {
    address public  manager;
    address payable[] public  participants;

    constructor() {
        manager = msg.sender; //global variable
    }

    receive() external payable {
        require(msg.value == 1 ether, "1 Ether required");
        participants.push(payable(msg.sender));
     }


    function getBalance() public  view returns (uint) {
        require(msg.sender == manager, "Only manager can see balance");
        return address(this).balance;
    }

    function random() internal  view returns (uint){
       return  uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, participants.length)));
    }

    function setlectWinner () public returns(address) {
        require(msg.sender == manager, "Only manager can be select winner");
        require(participants.length >= 3);
        
        uint r = random();
        address payable  winner;
        uint index = r % participants.length;
        winner = participants[index];
        winner.transfer(getBalance());
        participants =  new address payable[](0);
        return winner;
    }
 }