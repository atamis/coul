require 'rubygems'
require 'bundler/setup'
Bundler.setup(:default)
require 'parslet'

module Coul
  class Parser < Parslet::Parser
    rule(:message) { match('\s').maybe >> header.as(:header) >> body >> str("\n") >> match('\s').maybe}

    rule(:header) { str("COUL " + VERSION + " ")}

    rule(:body) { ping | pong | msg | smsg}

    rule(:ping) { str("PING").as(:command)}
    rule(:pong) { str("PONG").as(:command)}

    rule(:msg)  do
      str("MSG").as(:command) >> str(" ") >>
      match('\w').repeat.as(:channel) >> str("\n") >>
      msg_body
    end

    rule(:smsg)  do
      str("SMSG").as(:command) >>
      str(" ") >> match('\w').repeat.as(:nick) >>
        str("@") >> (hostname | ip).as(:server) >>
      str(" ") >> match('\w').repeat.as(:channel) >>
      str(" ") >> match('\w').repeat.as(:timestamp) >>
      str("\n") >>
      msg_body
    end

    rule(:msg_body) do
      ((str("\n\n").absent? >> match('[\s\S]')).repeat >>
      str("\n")).as(:message) # the last newline in the message
      #match(/([\s\S]*)(?=\n\n)/)
    end

    root :message

    rule(:ip) {
      (ip_quad >> str('.')).repeat(3) >> ip_quad
    }

    rule(:ip_quad) {
      (
        str('2') >> (match['1-4'] >> match['0-9'] | str('5') >> match['0-5']) |
        str('1') >> match('[0-9]') >> match('[0-9]') |
        match('[0-9]') >> match('[0-9]') |
        match('[0-9]')
      )
    }


    rule(:hostname) do
      hostnamename >> (str('.') >> hostnamename).repeat
    end

    rule(:hostnamename) do
      match('\w') >> (str('-') | match('\w')).repeat
    end
  end
end
