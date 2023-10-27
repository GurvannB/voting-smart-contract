import React, { useEffect, useState } from 'react';
import { ethers } from "ethers";
import {provider, votingContract} from "./contract-config";

const metamaskProvider = new ethers.providers.Web3Provider(window.ethereum);
const signer = metamaskProvider.getSigner();

function App() {
	const [greet, setGreet] = useState('');
	const [accounts, setAccounts] = useState([]);

	const contract = new ethers.Contract(votingContract.contractAddress, votingContract.ABI, provider);

	useEffect(() => {
		console.log("Triggered")
		const getAccounts = async () => {
			const accounts = await metamaskProvider.listAccounts();
			setAccounts(accounts);
		}

		getAccounts().catch(console.error)
	}, [contract, metamaskProvider]);

	return (
		<div className="container">
			<div className="row mt-5">

				<div className="col">
					<h3>Hello {greet}</h3>
					<h3>Accounts {accounts}</h3>
				</div>
			</div>
		</div>
	);
}

export default App;
