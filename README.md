# ZK Merkle Airdrop Pro

This repository provides a production-ready solution for distributing ERC20 tokens to a large list of addresses. Instead of storing every eligible address on-chain (which is extremely expensive), it uses a Merkle Root to verify claims.

## How it Works


1. **Off-Chain:** Generate a Merkle Tree from a list of addresses and amounts. The root is calculated and deployed to the contract.
2. **Distribution:** Provide each user with their "Merkle Proof" (a small array of hashes).
3. **On-Chain:** The user calls `claim()`. The contract hashes their address/amount with the proof to see if it matches the stored root.

## Features
* **Minimal Gas Cost:** Storage is $O(1)$ regardless of the number of users.
* **Double-Claim Protection:** Uses a bitmapping system to track who has already claimed.
* **Security:** Prevents unauthorized claims via cryptographic proof validation.

## Tech Stack
* **Solidity:** 0.8.20
* **Library:** OpenZeppelin Cryptography (MerkleProof)
* **Off-chain Tooling:** JavaScript/Ethers.js for tree generation.
