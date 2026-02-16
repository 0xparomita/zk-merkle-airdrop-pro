const { MerkleTree } = require('merkletreejs');
const keccak256 = require('keccak256');
const { ethers } = require('ethers');

const participants = [
    { addr: "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", amount: ethers.parseEther("100") },
    { addr: "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db", amount: ethers.parseEther("200") }
];

const leaves = participants.map(p => 
    keccak256(ethers.solidityPacked(["address", "uint256"], [p.addr, p.amount]))
);

const tree = new MerkleTree(leaves, keccak256, { sortPairs: true });
const root = tree.getHexRoot();

console.log("Merkle Root:", root);

// To claim for the first participant:
const leaf = leaves[0];
const proof = tree.getHexProof(leaf);
console.log("Proof for User 0:", proof);
