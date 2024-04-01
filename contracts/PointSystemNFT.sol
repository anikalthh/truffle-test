// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract PointSystemNFT is ERC721 {
    address public owner;
    uint256 public requiredPoints;
    mapping(address => uint256) public userPoints;
    mapping(address => bool) public hasClaimedNFT; // Track if a user has claimed an NFT

    event NFTClaimed(address indexed user, uint256 tokenId);

    constructor(string memory _name, string memory _symbol, uint256 _requiredPoints) ERC721(_name, _symbol) {
        owner = msg.sender;
        requiredPoints = _requiredPoints;
    }

    function claimNFT() external {
        require(userPoints[msg.sender] >= requiredPoints, "User does not have enough points to claim NFT");
        require(!hasClaimedNFT[msg.sender], "User has already claimed an NFT");

        uint256 tokenId = uint256(keccak256(abi.encodePacked(msg.sender, block.number))); // Generate unique token ID
        _mint(msg.sender, tokenId);
        hasClaimedNFT[msg.sender] = true; // Mark user as having claimed an NFT
        emit NFTClaimed(msg.sender, tokenId);
    }

    function setUserPoints(address user, uint256 points) external {
        require(msg.sender == owner, "Only owner can set user points");
        userPoints[user] = points;
    }
}
