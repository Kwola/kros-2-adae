var redis = require("redis").createClient();
redis.subscribe("sent");

var express = require('express');
var app = express();

var fs = require('fs');

// Local code
/**var options = {
  NPNProtocols: ['http/2.0', 'spdy', 'http/1.1', 'http/1.0']
};**/

// Use this for production
var options = {
  key: fs.readFileSync('/etc/ssl/adae.key'),
  cert: fs.readFileSync('/etc/ssl/cert_chain.crt'),
  NPNProtocols: ['http/2.0', 'spdy', 'http/1.1', 'http/1.0']
};

var server = require('https').createServer(options, app);
var io = require('socket.io')(server);

io.on("connection", function(socket){
  console.log("connected socket")

  socket.on("disconnect", function(){
    console.log("client disconnected");
    socket.disconnect();
  });

  socket.on('room', function(room) {
    socket.join(room);
  });
});

redis.on("message", function(channel, message){
  console.log("message sent");

  var info = JSON.parse(message);

  console.log(channel);
  console.log(info);  

  //io.sockets.emit(channel, info);
  io.sockets.in(channel).emit('message', 'what is going on, party people?');
});

server.listen(40091, function(){
    console.log('Express server listening on port 40091');
});