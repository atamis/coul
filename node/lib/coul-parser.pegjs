
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
  = ping / pong / msg

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


msg_body
  = ((! "\n\n" .)* "\n")
