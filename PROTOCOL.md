# Protocol

Version 0.1

Servers are identified either by their addressable IPs or a DNS
resolvable URL.
Users are identified by their nickname and the
server they are connected to separated by an @ sign.

## Text

All messages start with "COUL 0.1", where 0.1 is the current
version number. The end of a message is indicated by an empty line.

### HELLO

A hello message, indicating that a client is ready to receive messages.
The server returns the random unique name automatically assigned.

COUL 0.1 HELLO

COUL 0.1 WELCOME
<NAME>

### PING

COUL 0.1 PING

COUL 0.1 PONG

### NAME

COUL 0.1 NAME
<name>

COUL 0.1 NAME CONFIRMED

### MSG

This message has 2 uses. If a client sends it to a server, it indicates
that the client would like to submit the message to a particular
channel. If the server send it to the client, it indicates that a
message has been posted to a particular channel. The timestamp field is
ignored or not present in the client's message.

COUL 0.1 MSG <CHANNEL>
<message, possibly multiple lines>

### SMSG

Indicates that a particular message was sent
to a given channel by a nick at the timestamp.
used by servers to indicate an incoming message,
and in links. Timestamp is in seconds since epoch,
with the possibility of fractional seconds.

COUL 0.1 SMSG <NICK>@<SERVER> <CHANNEL> <TIMESTAMP>
<message, possibly multiple lines>

### STATUS

COUL 0.1 STATUS

COUL 0.1 STATUS RESP
UPTIME: <uptime in seconds>
NAME: <name of the server>
SERVER: <server software name and version>
PROTOCOLS: <COUL protocol version supported>
BINARY: <YES or NO, whether the server supports the binary protocol>
USERS: <number of users connected>
CHANNELS: <number of channels>
LINK NAMES: <names of linked servers>
LINK ADDR: <addresses of linked servers, human readable if possible>
LINK UPTIME <uptime of the links (not the remote servers themselves)>

### ERROR

Used by the server to indicate that there's a problem with the last
message recieved. Error message is optional.

COUL 0.1 ERROR <CODE>
<Error message?>

### LINK

Requests to form a link between one server and another. The requesting
server indicates its name, and if the other server approves, it sends
back yes, and if not, no. There's no inherent authentication, but
servers could restrict links to a set of known names, addresses, or
both.

COUL 0.1 LINK
<NAME>

COUL 0.1 LINK
<YES or NO>

## Binary
