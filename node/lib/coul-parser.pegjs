
{
  function fixtext(obj) {
    flat = []
    flat = flat.concat.apply(flat, obj)
    return flat.join("").replace(/,/g, "")
  }

  function fixmessage(obj) {
    return obj[0].map(function(x) {return x[1]}).join("") + "\n"
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
  = ping / pong / msg / smsg / alert

ping
  = command:"PING" { return {"command": command}}

pong
  = command:"PONG" { return {"command": command}}

msg
  = command:"MSG" " " channel:letters "\n" message:msg_body {
  return {"command": command,
          "channel": channel.join(""),
          "message":fixmessage(message)
  }
}

smsg
  = command:"SMSG" " " nick:letters "@" server:server " " channel:letters " " timestamp:timestamp "\n" message:msg_body {
  return {"command": command,
          "nick": nick.join(""),
          "server": fixtext(server),
          "timestamp": fixtext(timestamp),
          "channel": channel.join(""),
          "message":fixmessage(message)
  }
}


alert
  = command:"ALERT" " " source:("SERVER" / "NETWORK") " " timestamp:timestamp "\n" message:msg_body {
  return {
    "command":command,
    "source":source,
    "timestamp": fixtext(timestamp),
    "message":fixmessage(message)
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
