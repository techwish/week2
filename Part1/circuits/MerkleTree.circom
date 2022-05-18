pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/poseidon.circom";
include "../node_modules/circomlib/circuits/mux1.circom";

//Given all 2n already hashed leaves of an n-level tree, 
//compute the Merkle root.

//Helper template to compute hashes of upper levels
template HelpComputeHashes(m) {
    signal input Lower[2**m];
    signal output Upper[m];  
    component Hashes[m];
    for(var i = 0; i < m; i++) {
        Hashes[i] = Poseidon(2);
        Hashes[i].inputs[0] <== Lower[i * 2];
        Hashes[i].inputs[1] <== Lower[i * 2 + 1];
        Hashes[i].out ==> Upper[i];
  }
}

template CheckRoot(n) { // compute the root of a MerkleTree of n Levels 
    signal input leaves[2**n];
    signal output root;

    //[assignment] insert your code here to calculate the Merkle root from 2^n leaves
    component ComputeHashes[n];
    for(var  j = n - 1; j >= 0; j--) {
        ComputeHashes[j] = HelpComputeHashes(j);
        for (var i = 0; i < (1 << (n+1)); i++){
            if (j == n-1){
                ComputeHashes[j].Lower[i] <== leaves[i];
            } else {
                ComputeHashes[j].Lower[i] <== ComputeHashes[j+1].Upper[i];
            }       
        }
    }
    if (n > 0) {
        root <== ComputeHashes[0].Upper[0];
    } else {
        root <== leaves[0];
    }
}

//Given an already hashed leaf and 
//all the elements along its path to the root, 
//compute the corresponding root.

template HashLeftRight() {
    signal input left;
    signal input right;

    signal output hash;

    component hasher = Poseidon(2);
    left ==> hasher.inputs[0];
    right ==> hasher.inputs[1];

    hash <== hasher.out;
}

template MerkleTreeInclusionProof(n) {
    signal input leaf;
    signal input path_elements[n][1];
    signal input path_index[n];
    signal output root;

    component hashers[n];
    component mux[n];

    signal levelHashes[n + 1];
    levelHashes[0] <== leaf;

    for (var i = 0; i < n; i++) {
        // Should be 0 or 1
        path_index[i] * (1 - path_index[i]) === 0;

        hashers[i] = HashLeftRight();
        mux[i] = MultiMux1(2);

        mux[i].c[0][0] <== levelHashes[i];
        mux[i].c[0][1] <== path_elements[i][0];

        mux[i].c[1][0] <== path_elements[i][0];
        mux[i].c[1][1] <== levelHashes[i];

        mux[i].s <== path_index[i];
        hashers[i].left <== mux[i].out[0];
        hashers[i].right <== mux[i].out[1];

        levelHashes[i + 1] <== hashers[i].hash;
    }

    root <== levelHashes[n];
}
