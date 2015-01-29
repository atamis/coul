
{
  function fixtext(obj) {
    flat = []
    flat = flat.concat.apply(flat, obj)
    return flat.join("").replace(/,/g, "")
  }
}

start
  = message

maybespace
  = [ \t\n]*

letter
  = [a-zA-Z]

letters
  = letter+


message
  = maybespace "COUL 0.1.0 " body "\n" maybespace

body
  = ping / pong / msg / smsg

ping
  = command:"PING" { return {"command": command}}

pong
  = command:"PONG" { return {"command": command}}

msg
  = command:"MSG" " " channel:letters "\n" message:msg_body {
  return {"command": command,
          "channel": channel.join(""),
          "message":message[0].map(function(x) {return x[1]}).join("") + "\n"
  }
}

smsg
  = command:"SMSG" " " nick:letters "@" server:server " " channel:letters " " timestamp:timestamp "\n" message:msg_body {
  server_flat = []
  server_flat = server_flat.concat.apply(server_flat, server)
  console.log("new: ", fixtext(server))
  return {"command": command,
          "nick": nick.join(""),
          "server": fixtext(server),
          "timestamp": fixtext(timestamp),
          "channel": channel.join(""),
          "message":message[0].map(function(x) {return x[1]}).join("") + "\n"
  }
}

msg_body
  = ((! "\n\n" .)* "\n")

server
  = ip / hostname

hostname
  = hostnamename ("." hostnamename)+

hostnamename
  = letter (letter / '-')+

ip
  = ip_quad '.' ip_quad '.' ip_quad '.' ip_quad

ip_quad
  = ('2' (([0-4] [0-9]) / ('5' [0-5]))) /
    ('1' [0-9] [0-9]) /
    ([0-9] [0-9]) /
    [0-9]

timestamp
  = [0-9]+ ('.' [0-9]+)?
