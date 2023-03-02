const path = require('path');
const express = require('express');
const app = express();
const http = require('http');
const server = http.createServer(app);
const { Server } = require("socket.io");
const port = 3000;
const io = new Server(server, {
    cors: {
        origin: "http://localhost:3000",
        methods: ["GET", "POST"],
    }
});


//event listener for a client to make a connection
//A socket represents an individual client
io.on('connection', (socket) => {
    console.log(`User Connected: ${socket.id}`);

    socket.on("push_game", (data) => {
        console.log(socket.id + data);

        //broadcast will emit to all other vlients except the on that sent the data
        socket.broadcast.emit("pull_game");
    });
});

server.listen(port, () => {
    console.log(`SERVER LISTENING ON PORT ${port}`);
});