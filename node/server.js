/*
 * Thanks, https://gist.github.com/creationix/707146
 */

// Load the TCP Library
net = require('net');
parser = require('./lib/wrapper')
factory = require('./lib/factory')
version = require('./lib/version')

console.log("Launching coul-node " + version)

var options = {
  "hostname":"localhost",
  "port":2000
}

function randnick() {
    var text = "";
    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    for( var i=0; i < 5; i++ )
        text += possible.charAt(Math.floor(Math.random() * possible.length));

    return text;
}

// Keep track of the chat clients
var clients = [];

// Start a TCP Server
net.createServer(function (socket) {

  // Identify this client
  socket.nick = randnick()
  socket.buffer = ""
  console.log(socket.nick + " from " + socket.remoteAddress + ":" + socket.remotePort + " joined.")

  // Put this new client in the list
  clients.push(socket);

  // Send a nice welcome message and announce
  socket.write(factory.now.alert("SERVER", "Welcome to coul-node " + version));
  broadcast(factory.now.alert("SERVER", socket.nick + " has joined."))

  // Handle incoming messages from clients.
  socket.on('data', function (data) {
    socket.buffer = socket.buffer + data;
    var parsed;
    if (socket.buffer.slice(-2) == "\n\n") {
      try {
        parsed = parser(socket.buffer);
      } catch(e) {
        socket.write(factory.now.alert("SERVER", "ERROR: " + e.message))
      }
      switch(parsed.command) {
        case("PING"):
          socket.write(factory.pong);
          break;
        case("MSG"):
          broadcast(factory.now.smsg(socket.nick, options.hostname, parsed.channel, parsed.message), socket);
          break;
      }
      buffer = ""
    }
  });

  // Remove the client from the list when it leaves
  socket.on('end', function () {
    clients.splice(clients.indexOf(socket), 1);
    broadcast(factory.now.alert("SERVER", socket.nick + " left the chat.\n"));
  });

  // Send a message to all clients
  function broadcast(message, sender) {
    clients.forEach(function (client) {
      // Don't want to send it to sender
      if (client === sender) return;
      client.write(message);
    });
    // Log it to the server output too
    //process.stdout.write(message)
  }

}).listen(options.port);

// Put a friendly message on the terminal of the server.
console.log("Chat server running at port 2000");

