require 'factory'

module Coul
  class Client
    attr_accessor :sock, :nick, :link, :link_name
    def initialize(socket, clients, engine, logger=NullLogger.new)
      @sock = socket
      @clients = clients
      @engine = engine
      @buffer = ""
      @link = false
      @link_name = ""
      @log = logger
      @nick = rand(9999)
    end

    def ident
      ary = @sock.peeraddr(:hostname)
      return ary[2] + ":" + ary[1].to_s
    end

    def listen
      @engine.joined(nick)

      @log.debug ident + " listening"
      while !(@sock.closed?) && line = @sock.gets
        begin
          if line != "\n"
            @buffer += line
          else
            # Process the buffer
            @buffer += line
            process(@buffer)
            @buffer = ""
          end
        rescue Parslet::ParseFailed => failure
          @log.error "Parse Error:" + failure.cause.ascii_tree
        rescue => e
          @log.error "ERROR: " + e.class.to_s + " " + e.message
          @log.error e.backtrace
          @buffer = ""
        end
      end

    ensure
      @clients.delete(self)
      @engine.left(nick)
      if !@sock.closed?
        @log.debug ident + " socket closed."
        @sock.close
      end
    end

    def process(buffer)
      @engine.client_process(self, buffer)
    end

    def send(message)
      if !@sock.closed?
        @sock.puts(message)
      end
    end

    def close
      puts "Closing " + ident

      #TODO: do server shutdown better.
      @sock.puts("Server shutting down.")
      @sock.close
    end
  end
end
