require 'factory'

module Coul
  class Engine
    include Factory
    def initialize(hostname, clients, logger=NullLogger.new)
      @clients = clients
      @hostname = hostname
      @parser = Coul::Parser.new
      @log = logger
    end

    def client_process(source, message)
      parsed = @parser.parse(message)
      case parsed[:command]
      when "PING"
        ping(source)
      when "MSG"
        msg(source, parsed[:channel], parsed[:message])
      end
    end

    def ping(source)
      source.send(build_pong)
    end

    def msg(source, channel, message)
      @log.debug "Message from " + source.ident
      @clients.each do |c|
        if c != source
          c.send(build_smsg(source.nick, @hostname, channel, Time.now.to_f, message))
        end
      end
    end

  end

end
