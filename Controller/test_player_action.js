const express = require('express');
const app = express();
const http = require('http');
const { Server } = require('socket.io');
const cors = require("cors")

//cors prevents connection errors
app.use(cors());

const server = http.createServer(app);

const io = new Server(server, {
    cors: {
        origin: "http://localhost:3000",
        methods: ["GET", "POST"],
    }
});

//test game object
gameObject = {
    cards: 12,
    contested_zone: 4,
    myTurn: false,
    myHealth: 0,
    opponentHealth: 12, 
    opponentName: 'BAD GUY' 
  }

//event listener for a client to make a connection
//A socket represents an individual client
io.on("connection", (socket) => {
    console.log(`User Connected: ${socket.id}`)

    socket.on("send_game", (data) => {
        console.log(data);
        console.log(data.message);

        //broadcast will emit to all other clients except the one that sent the data
        socket.broadcast.emit("receive_game", gameObject)
    })
})

server.listen(3001, () =>{
    console.log("SERVER IS RUNNING");
})

