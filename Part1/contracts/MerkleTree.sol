//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import { PoseidonT3 } from "./Poseidon.sol"; //an existing library to perform Poseidon hash on solidity
import "./verifier.sol"; //inherits with the MerkleTreeInclusionProof verifier contract

contract MerkleTree is Verifier {
    uint256[] public hashes; // the Merkle tree in flattened array form
    uint256 public index = 0; // the current index of the first unfilled leaf
    uint256 public root; // the current Merkle root

    constructor() {
        // [assignment] initialize a Merkle tree of 8 with blank leaves
        for (unit i=1; i<8; i++){
            unit256[i]=0;
        }
    }

    function insertLeaf(uint256 hashedLeaf) public returns (uint256) {
        // [assignment] insert a hashed leaf into the Merkle tree
          unit[8] = poseidon(unit[0], unit[1]);
          unit[9] = poseidon(unit[2], unit[3]);
          unit[10] = poseidon(unit[4], unit[5]);
          unit[11] = poseidon(unit[6], unit[7]); 
          unit[12] = poseidon(unit[8], unit[9]); 
          unit[13] = poseidon(unit[10], unit[11]);  
          root = poseidon(unit[12], unit[13]);
    }

    function verify(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[1] memory input
        ) public view returns (bool) {

        // [assignment] verify an inclusion proof and check that the proof root matches current root

    
    }
}
