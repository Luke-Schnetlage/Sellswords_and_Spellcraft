const path = require('path');
const express = require('express');
const app = express();
const http = require('http');
const server = http.createServer(app);
const { Server } = require("socket.io");
const io = new Server(server);

app.get('/', (req, res) => {
    console.log("debug #0");
    var root = {'root':path.dirname(__dirname)};
    res.sendFile('./View/test_game.html',root);
});



io.on('connection', (socket) => {
    console.log("debug #2");
    socket.on('select_deck_push', (deck) => {
        console.log("debug #3");
        io.emit('select_deck_pull', deck);
    });
});

server.listen(3000, () => {
    console.log('listening on *:3000');
});