import { Contract, ethers } from 'ethers';

const provider = new ethers.providers.JsonRpcProvider('http://localhost:8545');

const contracts_names = [
    "Admin",
    "Bank",
    "Voting",
    "Whitelist"
];

export let contracts = new Map<string, Contract>;
const contract_adresses = require("../../keys.json").contractsAdress
contracts_names.forEach(function (name) {
    const contract_json_prototype = require(`/build/contracts/${name}.json`);
    contracts.set(name, new ethers.Contract(
        contract_adresses[contract_json_prototype.contractName],
        contract_json_prototype.abi,
        provider
    ))
})