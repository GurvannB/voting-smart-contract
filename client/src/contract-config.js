import votingInfos from "./artifacts/Voting.json"
import {ethers} from "ethers";

export const votingContract = {
    contractAddress: "0x5FbDB2315678afecb367f032d93F642f64180aa3",
    ABI: votingInfos.abi
}

export const provider = new ethers.providers.WebSocketProvider("ws://localhost:8545");
