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
require 'client'
require 'engine'
require 'util'

require 'pp'
require 'socket'

log.debug 'Loading configuration'

AppData.config do
  parameter :port
  parameter :hostname
end

require './config.rb'

log.debug 'Testing parser'

p = Coul::Parser.new

msg = <<END
COUL 0.1 MSG bots
This is a test.
This is another test.

END

smsg = <<END
COUL 0.1 SMSG indigo@192.168.1.2 bots 5.5
This is a test.

END

alert = <<END
COUL 0.1 ALERT SERVER 5504.253
This is a server alert.

END

begin
  log.debug p.parse(msg)
  log.debug p.parse(smsg)
  log.debug p.parse(alert)
  log.debug p.hostname.parse("mail.test.com")
  log.debug p.ip.parse("99.255.255.255")
rescue Parslet::ParseFailed => failure
  log.debug failure.cause.ascii_tree
end


clients = []
engine = Coul::Engine.new(AppData.hostname, clients, log)

server = TCPServer.new AppData.port # Server bind to port 2000

Signal.trap("INT") do 
  puts "Safe shutdown"
  clients.each do |client|
    client.close
  end
  exit
end

log.info "Now listening on #{AppData.port}"

loop do
  sock = server.accept    # Wait for a client to connect
  Thread.new do
    begin
      c = Coul::Client.new(sock, clients, engine, log)
      clients << c
      log.debug c.ident + " connected."

      c.listen
    rescue => e
      log.error "ERROR: " + e.message
      log.error e.backtrace
    end
    log.debug c.ident + " disconnected"
    client.close
  end
end

