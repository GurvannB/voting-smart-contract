const fs = require('fs');

let Admin=artifacts.require("../contracts/Admin.sol");
let Bank=artifacts.require("../contracts/Bank.sol");
let Voting=artifacts.require("../contracts/Voting.sol");
let Whitelist=artifacts.require("../contracts/Whitelist.sol");

module.exports = function(deployer) {
    deployer.deploy(Admin).then(
        () => deployer.deploy(Bank).then(
            () => deployer.deploy(Voting).then(
                () =>  deployer.deploy(Whitelist).then( () => {
                    let keys_file = require("../keys.json");
                    keys_file.contractsAdress = {
                        "Admin" : `${Admin.address}`,
                        "Bank" : `${Bank.address}`,
                        "Voting" : `${Voting.address}`,
                        "Whitelist" : `${Whitelist.address}`
                    };
                    fs.writeFileSync("../keys.json", JSON.stringify(keys_file));
        }
        ))));
    
};