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

msg = <<END
COUL 0.1 MSG bots
This is a test.
This is another test.

END

smsg = <<END
COUL 0.1 SMSG indigo@192.168.1.2 bots 5
This is a test.

END

begin
  pp p.parse(msg)
  pp p.parse(smsg)
  pp p.hostname.parse("mail.test.com")
  pp p.ip.parse("99.255.255.255")
rescue Parslet::ParseFailed => failure
  puts failure.cause.ascii_tree
end

hostname = "localhost"

clients = []
engine = Coul::Engine.new(hostname, clients)

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

