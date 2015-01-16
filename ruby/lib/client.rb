
module Coul
  class Client
    attr_accessor :sock, :nick
    def initialize(socket, clients, engine)
      @sock = socket
      @clients = clients
      @engine = engine
      @buffer = ""
      @nick = rand(9999)
    end

    def ident
      ary = @sock.peeraddr(:hostname)
      return ary[2] + ":" + ary[1].to_s
    end

    def listen

      while line = @sock.gets
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
          puts failure.cause.ascii_tree
        rescue => e
          puts "ERROR: " + e.message
          puts e.backtrace
          @buffer = ""
        end
      end

    ensure
      @sock.close
    end

    def process(buffer)
      @engine.client_process(self, buffer)
      return

      puts ident + "- " + buffer
      @clients.each do |c|
        begin
          c.send ident + "- " + buffer
        rescue => e
          c.send "ERROR: " + e.message
        end
      end
    end


    def send(message)
      @sock.puts(message)
    end
  end
end
