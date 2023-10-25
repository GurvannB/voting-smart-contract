const fs = require('fs');

let Voting=artifacts.require("../contracts/Voting.sol");

const keys_location = `${process.cwd()}/../keys.json`;
let keys_file = require(keys_location);
module.exports = function(deployer) {
    deployer.deploy(Voting);
};
