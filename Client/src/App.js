import './App.css';
import io from 'socket.io-client';
import { useEffect, useState } from 'react';

//connects to server
const socket = io.connect("http://localhost:3001");


function App() {
  //variables used to send and receive games
  const [game, setGame] = useState("");
  const [gameReceived, setGameReceived] = useState("");

  //when called, send the game variable to the backend
  const sendGame = () => {
    socket.emit("send_game", { game })
  };

  //event listener for receieve_game
  //once event happens, update gameReceieved variable
  useEffect(() => {
    socket.on("receive_game", (data) => {
      console.log(Object.values(data))
      setGameReceived(Object.values(data))
    })
  }, [socket])


  return (
    <div className="App">
      <input placeholder='game...' onChange={(event) => {
        setGame(event.target.value);
        }}/>
      <button onClick={sendGame}>Send Game</button>
      <h1>Game</h1>
      { gameReceived}
    </div>
  );
}

export default App;
