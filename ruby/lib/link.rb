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
      @parser = Parser.new
      @log = log
      @log.debug "Linking to " + ident
      @retry_count = 0
    end

    def connect
      Thread.new do
        catch(:done) do
          loop do
            begin
              @sock = TCPSocket.new(@name, @port)
              @sock.puts Factory.build_link(@me)
              @retry_count = 0
              while buf = read_buffer
                puts buf.inspect
                resp = @parser.parse(buf)
                puts resp.inspect
                next if resp[:command] != "LINK"
                if resp[:message] != "YES\n"
                  @log.warn ident + " link rejected"
                  throw :done
                else
                  @log.info "Link with " + ident + " confirmed."
                  @engine.link_established(ident)
                  break
                end
              end
              while buf = read_buffer
                puts buf.inspect
                resp = @parser.parse(buf)
                puts resp.inspect
                @engine.redistribute(ident, resp)
              end
            rescue Errno::ECONNREFUSED
              @retry_count += 1
              @log.warn "Link to " + ident + " refused, retry in " + retry_sleep.to_s
              sleep(retry_sleep)
            rescue Exception => e
              puts e.message
              puts e.backtrace
              sleep(10)
            end
          end
        end

      end.abort_on_exception
    end

    def retry_sleep
      [@retry_count*15, 90].min
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
