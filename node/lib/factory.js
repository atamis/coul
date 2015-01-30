var version = require('./version')

module.exports = (function() {
  function header() {
    return "COUL " + version + " "
  }

  this.ping = function() {
    return header() + "PING\n\n"
  }

  this.pong = function() {
    return header() + "PONG\n\n"
  }

  this.smsg = function(nick, server, channel, timestamp, message) {
    if (message.slice(-1) != "\n") {
      message = message + "\n"
    }
    return header() + "SMSG " + nick + "@" + server + " " + channel + " " + timestamp + "\n" + message + "\n"
  }

  this.msg = function(channel, message) {
    if (message.slice(-1) != "\n") {
      message = message + "\n"
    }
    return header() + "MSG " + channel + "\n" + message + "\n"
  }

  return this;

})()
