require 'factory'
require 'parser'
require 'util'

module Coul
  class Link
    def initialize(me, name, port, engine, log = NullLogger.new)
      @me = me
      @name = name
      @port = port
      @engine = engine
      @clients = clients
      @parser = Parser.new
      @log = log
      @log.debug "Linking to " + ident

    end

    def connect
      Thread.new do
        begin
          @sock = TCPSocket.new(@name, @port)
          @sock.puts Factory.build_link(ident)
          while buf = read_buffer
            puts buf.inspect
            resp = @parser.parse(buf)
            puts resp.inspect
            next if resp[:command] != "LINK"
            if resp[:message] != "YES\n"
              @log.warn ident + " link rejected"
              return
            else
              @log.info "Link with " + ident + " confirmed."
              break
            end
          end
          while buf = read_buffer
            puts buf.inspect
            resp = @parser.parse(buf)
            puts resp.inspect
            engine.redistribute(resp)
          end
        rescue Exception => e
          puts e.message
          puts e.backtrace
        end

      end.abort_on_exception
    end

    def ident
      "#{@name}:#{@port}"
    end

    def read_buffer
      buffer = ""
      loop do
        line = @sock.gets
        buffer += line.to_s
        if buffer.slice(-2, 2) == "\n\n"
          break
        end
      end
      return buffer
    end
  end
end
