require 'rubygems'
require 'bundler/setup'
Bundler.setup(:default)
require 'parslet'

module Coul
  class Parser < Parslet::Parser
    rule(:message) { header.as(:header) >> body >> str("\n")}

    rule(:header) { str("COUL " + VERSION + " ")}

    rule(:body) { ping | pong }

    rule(:ping) { str("PING").as(:command)}
    rule(:pong) { str("PONG").as(:command)}

    root :message
  end
end
