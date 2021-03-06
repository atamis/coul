# POSTMORTEM

## What I did

You can read my full list of goals in the README in this repo, but to
quickly summarize, I wanted to build a series of server programs and
clients implementing a multi-server federated chat protocol.  I had
a number of servers and clients planned in several languages, and a number
of "stretch goals".

## Success

Unfortunately, I only got 2 servers and 1 client finished. The protocol
I made passed messages in plain text, which meant that I had to
implement a parser to interpret them. This turned out to be a huge time
sink, and because I didn't realize this, I didn't take advantage of one of
the cross-language parsers to save myself some work. Writing my grammar in
Yacc, then finding converters for the various languages would have saved
me some time.

Ironically, one of my stretch goals was a "binary" protocol, which I was
planning to implement with Google's protobuf, which takes a single
protocol definition file and, using any number of converters, makes
compatible binary parser and message builders for many common languages.
This would have sped up the process immensely, and allowed me to focus on
the stated goal, network programming.

Although the servers work well, handle multiple connections, and pass
messages between them, I didn't have time to implement loop checking,
solid fault tolerance, or a decent UI. The 2 servers I implemented used
2 different styles of network programming: the Ruby server used Ruby's
built-in synchronous network libraries, while the Node.js implementation
used its built-in asynchronous style.

## What I Learned

My abilities to estimate the difficulty and effort required for any
particular part of a program is really rather bad. In fact, a lack of
foresight plagued this project.

## What I would do differently

If I were to do this particular project over completely, I would consider,
as I stated in the "Success" section, using Google's protobuf. Generally,
for future projects, I might also consider focusing the project more
carefully.  This project had a number of different goals: study network
programming, learn some new languages, implement a novel and untested
protocol, and experiment with multi-server networks on the application
layer. This is, to be honest, too many goals, and a number of them simply
couldn't be explored.  Focusing the project more closely--using a known
protocol, focusing on a single language, or a simpler goal program--would
have resulted in a more complete, and likely more useful, project.
