#!/usr/bin/env ruby
require 'logger'
log = Logger.new(STDOUT).tap do |log|
  log.progname = 'coul-ruby'
end

log.debug "Loading gems"

require 'rubygems'
require 'bundler/setup'
Bundler.setup(:default)
$LOAD_PATH.unshift(File.dirname(__FILE__) + "/lib")

require 'version'
require 'parser'
require 'factory'
require 'link'
require 'engine'

class ClientParser < Parslet::Parser
  rule(:input) {
    channel.as(:channel) >> str(':') >> (str("\n").absent? >> any).repeat.as(:message) >> str("\n")
  }

  rule(:channel) {
    match('\w').repeat
  }
  root(:input)
end

log.warn "coul-ruby client" + Coul::VERSION

if ARGV.length < 1
  log.error "Insufficient arguments: client.rb [server]:[port]"
  exit
end

server = ARGV[0].split(':')[0]
port = ARGV[0].split(':')[1]

log.info "Connecting to " + ARGV[0]

link = Coul::Link.new("manual_link:00", server, port, Coul::Engine.new("manual_link", [], link), log)
link.connect

loop do

end

def done
  puts "Exiting"
  @sock.close
  exit
end

Signal.trap("INT") do
  done()
end

