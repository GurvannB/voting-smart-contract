'use client'
import Terminal, { ColorMode, TerminalInput, TerminalOutput } from 'react-terminal-ui';
import { Voting, accounts } from '../interfaces/web3/contracts';
import React, { useState } from 'react';

let key_id = 0;
const url_sujet = "https://moonrocketeer.notion.site/Projet-individuel-Syst-me-de-vote-36ab58b861cf401ba00cc0780fcac1ee";

function addOutput(data : string){
  return <TerminalOutput  key={key_id++}>{data}</TerminalOutput>;
}

function addInput(data : string){
  return <TerminalInput  key={key_id++}>{data}</TerminalInput>;
}

export default function Home() {

  const [lineData, setLineData] = useState([
    addOutput('Bienvenue dans le système de vote, tapez "manuel" pour voir la liste des comandes disponibles')
  ]);

  function buttonUseWarning() {
    alert("Ceci est un interface en ligne de commande");
    alert("il n'y a pas d'usage prévu pour les bouttons");
  }

  function onInput(input: string) {
    let ld = [...lineData];
    ld.push(addInput(input));
    // const plain_input = input.toLocaleLowerCase().trim();
    const plain_input = input;
    if (plain_input === 'manuel') {
      ld.push(addOutput("il n'y a pas de manuel, vous étes seul"));
    } else if (plain_input.includes('nettoyer')) {
      ld = [];
    } else if (plain_input.includes('sujet')) {
      window.open(url_sujet);
    } else if (plain_input.includes('exit')) {
      window.location.replace("about:blank");
    } else if (plain_input.includes('utilisateurs')) {
      ld.push(addOutput(accounts()))
    } else if (plain_input.includes('détenteur')) {
      ld.push(addOutput(Voting?.owner()));
    } else if (plain_input.includes('dev')) {
      console.log("dev")
      console.log(Voting);
    } else if (plain_input.includes('hello')) {
      Voting?.helloWorld().then((raw) => console.log(raw)).catch(e => console.log(e))
    } else if (plain_input.includes('call')) {
      try {
        let attrib = Voting[plain_input.replace('call ','')];
        let result = attrib("0xdea504d061d4161cee06ef413b2135a2b6d4ca13");
        // if (typeof attrib === 'function') {
        //   result = attrib();
        // }
        // ld.push(addOutput(result));
        console.log(result);
      } catch (error) {console.log(error)}
    } else {
      ld.push(addOutput("commande non reconnue"));
    }
    setLineData(ld);
  };


  return (
    <div className="container">
      <Terminal
        name='Solidity Smart Contracts'
        colorMode={ColorMode.Dark}
        onInput={onInput}
        redBtnCallback={buttonUseWarning}
        yellowBtnCallback={buttonUseWarning}
        greenBtnCallback={buttonUseWarning}
      >
        {lineData}
      </Terminal>
    </div>
  )
}
