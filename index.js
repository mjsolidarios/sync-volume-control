const express = require('express');
const app = express();
const http = require('http');
const server = http.createServer(app);
const { Server } = require("socket.io");
const io = new Server(server, {
  cors: {
    origin: "https://sync-volume-server.herokuapp.com/",
    methods: ["GET", "POST"]
  }
});

app.get('/', (req, res) => {
    res.send('<h1>Hello world</h1>');
});

io.on('connection', (socket) => {
  console.log('a user connected');
  socket.on('disconnect', () => {
    console.log('user disconnected');
  });
  socket.on('volume', (value) => {
    socket.broadcast.emit(value);
  });
});

server.listen(process.env.PORT || 3000, () => {
  console.log('listening on server');
});