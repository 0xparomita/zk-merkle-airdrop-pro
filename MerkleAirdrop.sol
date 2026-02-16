// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleAirdrop {
    address public immutable token;
    bytes32 public immutable merkleRoot;

    // Track claimed status
    mapping(address => bool) public hasClaimed;

    event Claimed(address indexed account, uint256 amount);

    error AlreadyClaimed();
    error InvalidProof();

    constructor(address _token, bytes32 _merkleRoot) {
        token = _token;
        merkleRoot = _merkleRoot;
    }

    /**
     * @notice Claim tokens using a Merkle proof
     * @param _amount The amount of tokens eligible to claim
     * @param _proof The cryptographic proof that the user is in the tree
     */
    function claim(uint256 _amount, bytes32[] calldata _proof) external {
        if (hasClaimed[msg.sender]) revert AlreadyClaimed();

        // Verify the leaf: keccak256(abi.encodePacked(address, amount))
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(msg.sender, _amount))));
        
        if (!MerkleProof.verify(_proof, merkleRoot, leaf)) {
            revert InvalidProof();
        }

        hasClaimed[msg.sender] = true;
        require(IERC20(token).transfer(msg.sender, _amount), "Transfer failed");

        emit Claimed(msg.sender, _amount);
    }
}
