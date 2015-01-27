
start
  = message

maybespace
  = [ \t\n]*


message
  = maybespace "COUL 0.1.0 " body "\n" maybespace

body
  = ping / pong

ping
  = command:"PING" { return {"command": command}}

pong
  = command:"PONG" { return {"command": command}}
