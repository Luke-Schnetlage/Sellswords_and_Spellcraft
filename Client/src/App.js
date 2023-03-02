import './App.css';
import io from 'socket.io-client';
import { useEffect, useState } from 'react';

//connection to server
const socket = io.connect("http://localhost:3000");

function App() {

//variabls (states) used to send and receive game board
const [game, setGame] = useState("");
//might not need this state
const [gameReceived, setGameReceived] = useState("");

//when called, send the game object to the backend
const sendGame = () => {
  socket.emit("game_push", { game })
}

//event listener for game_pull
//once event happens, update the game object
useEffect(() => {
  socket.on("game_pull", (data) => {
    setGame(data.message);
  })
}, [socket])

  return (
    <div className="App">
      <input placeholder='Change Game State . . .' onChange={(event) =>{
        setGame(event.target.value);
      }}/>
      <button onClick={sendGame}>Send Game State</button> 
      <h1>Game State:</h1>
      { game }     
    </div>
  );
}

export default App;
