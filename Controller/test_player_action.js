const path = require('path');
const express = require('express');
const app = express();
const http = require('http');
const server = http.createServer(app);
const { Server } = require("socket.io");
const io = new Server(server);

app.get('/', (req, res) => {
    var root = {'root':path.dirname(__dirname)};
    res.sendFile('./View/test_game.html',root);
});



io.on('select_deck', (socket) => {
    socket.on('select_deck', (deck) => {
        io.emit('select_deck', deck);
    });
});

server.listen(3000, () => {
    console.log('listening on *:3000');
});