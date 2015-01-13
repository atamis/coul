require 'rubygems'
require 'bundler/setup'
Bundler.setup(:default)
$LOAD_PATH.unshift(File.dirname(__FILE__) + "/lib")

#require 'version'
#require 'parser'

#require 'pp'
require 'socket'


=begin
p = Coul::Parser.new

begin
  pp p.parse("COUL 0.1 PING\n")
rescue Parslet::ParseFailed => failure
  puts failure.cause.ascii_tree
end
=end

clients = []

def format_peeraddr(x)
  y = x.peeraddr(:hostname)
  return y[2] + ":" + y[1].to_s
end


server = TCPServer.new 2000 # Server bind to port 2000
loop do
  client = server.accept    # Wait for a client to connect
  Thread.new do
    clients << client
    client.puts "Hello !"
    client.puts "Time is #{Time.now}"
    puts format_peeraddr(client) + " connected."

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

    client.close
  end
end

