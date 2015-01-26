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

    def joined(nick)
      puts "sending alerts"
      @clients.each do |c|
        puts "sending alert"
        c.send(Factory.build_alert(:server, Time.now.to_f, "User #{nick} has connected."))
      end
    end

    def left(nick)
      @clients.each do |c|
        c.send(Factory.build_alert(:server, Time.now.to_f, "User #{nick} has disconnected."))
      end
    end

    def ping(source)
      source.send(Factory.build_pong)
    end

    def msg(source, channel, message)
      @log.debug "Message from " + source.ident
      @clients.each do |c|
        if c != source
          c.send(Factory.build_smsg(source.nick, @hostname, channel, Time.now.to_f, message))
        end
      end
    end

  end

end
