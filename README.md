# voting-smart-contract

## Générer des adresses de test pour la blockchain :
```shell
npx hardhat node 
```

## Compilation et déploiement des contrats
```shell
# Aller dans le répertoire "local"
npx hardhat compile
npx hardhat run --network localhost scripts/deploy.js
# Recopier l'adresse du contract dans ../local/src/contract-config.js
# Et recopier le json comme ce qui suit :
cp artifacts/contracts/Voting.sol/Voting.json ../client/src/artifacts
```

## Démarrer l'application
```shell
# Aller dans le répertoire "client"
npm start
```
