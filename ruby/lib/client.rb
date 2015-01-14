
module Coul
  class Client
    attr_accessor :sock
    def initialize(socket, clients, engine)
      @sock = socket
      @clients = clients
      @engine = engine
      @buffer = ""
    end

    def ident
      ary = @sock.peeraddr(:hostname)
      return ary[2] + ":" + ary[1].to_s
    end

    def listen

      begin
      while line = @sock.gets
        if line != "\n"
          @buffer += line
        else
          # Process the buffer
          process(@buffer)
          @buffer = ""
        end
      end
      rescue => e
        puts "ERROR: " + e.message
        puts e.backtrace
      end

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
