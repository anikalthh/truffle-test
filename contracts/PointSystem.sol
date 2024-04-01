// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PointSystem {
    address public owner;
    uint256 public requiredPoints;
    mapping(address => uint256) public userPoints;

    event NFTClaimed(address indexed user, uint256 tokenId);

    constructor(uint256 _requiredPoints) {
        owner = msg.sender;
        requiredPoints = _requiredPoints;
    }

    function claimNFT() external {
        require(userPoints[msg.sender] >= requiredPoints, "User does not have enough points to claim NFT");

        // Instead of checking balanceOf and minting an ERC721 token, emit an event indicating the NFT claim
        emit NFTClaimed(msg.sender, userPoints[msg.sender]);
        
        // Optionally, you can reset userPoints[msg.sender] to zero or perform other actions here
    }

    function setUserPoints(address user, uint256 points) external {
        require(msg.sender == owner, "Only owner can set user points");
        userPoints[user] = points;
    }
}
