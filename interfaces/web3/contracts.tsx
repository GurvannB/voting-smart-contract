import { Contract, ethers } from 'ethers';

const provider = new ethers.providers.JsonRpcProvider('http://localhost:8545');

const keys = require("../../keys.json");

export function accounts() {
    return JSON.stringify(Object.keys(keys.addresses), null, " ");
}

const contract_json_prototype = require(`/build/contracts/Voting.json`);
export let Voting: Contract = new ethers.Contract(
    keys.contractsAdress["Voting"],
    contract_json_prototype.abi,
    provider
);