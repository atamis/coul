# coul

## The Project

Coul is a multi-server federated chat system. This project's goal is to
build several different servers and clients using several different
languages and technologies. This is a project without significant
personal precedent, but I have confidence I'll be able to manage at
least 4 different servers.

### The Protocol

The protocol is quite simple, consisting of messages sent to dynamically
allocated chat rooms or to individuals. Servers connect to each other
and distribute their incoming messages to each other, while clients
connect to individual servers to submit messages for distribution.
Servers will also distribute their inter-server links to allow for
network health monitoring and neighbor discovery.

### Clients

Java -- very simple client without a lot of features.

Ruby -- bot framework, and a similarly simple client

C -- similarly simple

Extra goals:

Java GUI -- tabbed, multi server, nice formatting, preferences,
scripting.

"Perhaps another winter term" goals:

C GUI -- as above, but written in C. Even more work would be required to
make it work on more than one platform.

### Servers

Ruby -- standard syncronous reference implementation.

Node.js -- standard asyncronous reference implementation.

Erlang -- A syncronous OTP based implementation.

Go -- Yet another synchronous implementation.

Java -- Further synchronous implementations.

Extra goals:

Haskel -- Probably synchronous, but also pure functional.

"Perhaps another winter term" goals:

C -- Uses the same concepts, but without all the nice safety nets of the
other syncronous implementations.

### Other Stretch Goals

Upgrade to binary protocol: for extra efficiency particularly in
inter-server links, a binary protocol could be useful. Google's protobuf
looks useful in this regard.

Consistency: relatively easy for a single server, vastly more difficult
for a multi-server network.

Authentication: difficult, and very easy to screw up.

## The Learning Goals

Learn the basics of Erlang, Go, and Haskel. Learn network programming in
the same, and the languages I already know in other respects. Learn
server programming, particularly in cross-language situations.

## Resources

Real World Haskell: http://book.realworldhaskell.org/

Learn you some Erlang (for Great Good):
http://learnyousomeerlang.com/what-is-otp

Network Programming with Go (outdated): http://jan.newmarch.name/go/

## Evaluating Success

Multiple working server and client implementations, with possibly a few
extra goals implemented.
