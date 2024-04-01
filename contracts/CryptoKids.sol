// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract CryptoKids {
    // owner MUM
    address owner;

    // event // Log is by convention
    event LogKidFundingReceived(address addr, uint amount, uint contractBalance);

    constructor() {
        owner = msg.sender;
    }

    // define kid
    struct Kid {
        address payable walletAddress;
        string firstName;
        string lastName;
        uint releaseTime;
        uint amount;
        bool canWithdraw;
    }


    // add kid to contract
    Kid[] public kids;

    // Modifier
    modifier onlyOwner() {
        require(owner == msg.sender, "Only the owner can add kids");
        _; // applicable to any functions 
    }

    function addKid(address payable walletAddress, string memory firstName, string memory lastName, uint releaseTime, uint amount, bool canWithdraw) public onlyOwner {
        
        kids.push(Kid(
            walletAddress,
            firstName,
            lastName,
            releaseTime,
            amount,
            canWithdraw
        ));
    }

    function balanceOf() public view returns(uint) {
        return address(this).balance;
    }

    // deposit finds to contract, specifically to a kids's acct
    function deposit(address walletAddress) payable public {
        addToKidsBalance(walletAddress);
    }

    function addToKidsBalance(address walletAddress) private onlyOwner {
        for(uint i = 0; i < kids.length; i++) {
            if(kids[i].walletAddress == walletAddress) {
                kids[i].amount += msg.value;
                emit LogKidFundingReceived(walletAddress, msg.value, balanceOf());
            }
        }
    }

    function getIndex(address walletAddress) view private returns(uint) {
        for(uint i=0; i < kids.length; i++) {
            if(kids[i].walletAddress == walletAddress) {
                return i;
            }
        }
        return 999;
    }

    // kid checks if able to withdraw
    function availToWithdraw(address walletAddress) public returns(bool) {
        uint i = getIndex(walletAddress);
        require(block.timestamp > kids[i].releaseTime, "You cannot withdraw at this time");
        if (block.timestamp > kids[i].releaseTime) {
            kids[i].canWithdraw = true;
            return true;
        } else {
            return false;
        }
    }

    // withdraw money if of age
    function withdraw(address payable walletAddress) payable public {
        
        uint i = getIndex(walletAddress);
        require(msg.sender == kids[i].walletAddress, "You can only withdraw from your own account");
        require(kids[i].canWithdraw == true, "You are not able to withdraw at this time");
        kids[i].walletAddress.transfer(kids[i].amount);
    }
}
