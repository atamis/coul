var version = require('./version')

module.exports = factory = (function() {
  function header() {
    return "COUL " + version + " "
  }

  function process_body(body) {
    if (body.slice(-1) != "\n") {
      return body + "\n"
    } else {
      return body;
    }
  }

  this.ping = function() {
    return header() + "PING\n\n"
  }

  this.pong = function() {
    return header() + "PONG\n\n"
  }

  this.smsg = function(nick, server, channel, timestamp, message) {
    message = process_body(message)
    return header() + "SMSG " + nick + "@" + server + " " + channel + " " + timestamp + "\n" + message + "\n"
  }

  this.msg = function(channel, message) {
    message = process_body(message)
    return header() + "MSG " + channel + "\n" + message + "\n"
  }

  this.alert = function(source, timestamp, message) {
    if (source != "SERVER" && source != "NETWORK") {
      throw new Error("Source needs to be SERVER or NETWORK")
    }
    message = process_body(message)
    return header() + "ALERT " + source + " " + timestamp + "\n" + message + "\n"
  }

  this.now = {
  }

  this.now.smsg = function(nick, server, channel, message) {
    var now = new Date() / 1000;
    return factory.smsg(nick, server, channel, now, message);
  }

  this.now.alert = function(source, message) {
    var now = new Date() / 1000;
    return factory.alert(source, now, message);
  }

  return this;

})()
