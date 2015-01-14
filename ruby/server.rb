require 'rubygems'
require 'bundler/setup'
Bundler.setup(:default)
$LOAD_PATH.unshift(File.dirname(__FILE__) + "/lib")

require 'version'
require 'parser'
require 'client'
require 'engine'

require 'pp'
require 'socket'


p = Coul::Parser.new

begin
  pp p.parse("COUL 0.1 PING\n")
rescue Parslet::ParseFailed => failure
  puts failure.cause.ascii_tree
end

clients = []
engine = Coul::Engine.new(clients)

def format_peeraddr(x)
  y = x.peeraddr(:hostname)
  return y[2] + ":" + y[1].to_s
end


server = TCPServer.new 2000 # Server bind to port 2000
loop do
  sock = server.accept    # Wait for a client to connect
  Thread.new do
    begin
    c = Coul::Client.new(sock, clients, engine)
    clients << c
    sock.puts "Hello !"
    sock.puts "Time is #{Time.now}"
    puts c.ident + " connected."

      c.listen
    rescue => e
      puts "ERROR: " + e.message
      puts e.backtrace
    end

=begin
    while line = client.gets
      begin
        puts format_peeraddr(client) + "- " + line
        clients.each do |c|
          begin
            c.puts format_peeraddr(client) + "- " + line
          rescue => e
            c.puts "ERROR: " + e.message
          end
        end
      rescue => e
        puts "ERROR: " + e.message
      end
    end
=end

    client.close
  end
end

