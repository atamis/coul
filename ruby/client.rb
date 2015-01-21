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

parser = Coul::Parser.new

client_parser = ClientParser.new

log.info "Connecting to " + ARGV[0]


sock = TCPSocket.open(server, port)
@sock = sock
serv_buffer = ""

def done
  puts "Exiting"
  @sock.close
  exit
end

Signal.trap("INT") do
  done()
end

while true
  ready = select([sock, $stdin], nil, nil, nil)
  next if !ready
  ready[0].each do |s|
    if s == $stdin
      done if $stdin.eof
      line = $stdin.gets
      parsed = client_parser.parse(line)
      sock.puts(Coul::Factory.build_msg(parsed[:channel], parsed[:message]))

    elsif s == sock
      done if sock.eof
      line = s.gets
      serv_buffer += line
      if line == "\n"
        begin
          parsed = parser.parse(serv_buffer)
          serv_buffer = ""
        rescue Parslet::ParseFailed => failure
          puts failure.cause.ascii_tree
          serv_buffer = ""
          next
        end
        nick = parsed[:nick]
        server = parsed[:server]
        channel = parsed[:channel]
        timestamp = Time.at(parsed[:timestamp].to_f)
        message = parsed[:message]

        puts "#{nick}:#{server}!#{channel} - #{message.inspect}"

      end
    end
  end
end
