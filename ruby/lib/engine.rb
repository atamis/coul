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
      when "LINK"
        link(source, parsed[:message])
      end
    end

    def joined(nick)
      puts "sending alerts"
      @clients.each do |c|
        puts "sending alert"
        c.send(Factory.build_alert(:server, Time.now.to_f, "User #{nick} has connected.\n"))
      end
    end

    def left(nick)
      @clients.each do |c|
        c.send(Factory.build_alert(:server, Time.now.to_f, "User #{nick} has disconnected.\n"))
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

    def link(source, message)
      source.link = true
      source.link_name = message.to_s.chomp
      source.send(Factory.build_link("YES"))
      @log.warn "Feeding link to " + source.link_name
    end

    def redistribute(source, resp)
      if resp[:command] == "SMSG"
        @clients.each do |c|
          if c.link && c.link_name == resp[:server]
            next
          end
          c.send(Factory.build_smsg(resp[:nick], resp[:server], resp[:channel],
                                    resp[:timestamp], resp[:message]))
        end
      end
      
      if resp[:command] == "ALERT" && resp[:source] == "NETWORK"
        @clients.each do |c|
          if c.link && c.link_name == source
            next
          end
          c.send(Factory.build_alert(resp[:source] == "NETWORK" ? :network : :server, resp[:timestamp], resp[:message]))
        end
      end
    end

    def link_established(ident)
      @clients.each do |c|
        c.send(Factory.build_alert(:network, Time.now.to_f, "Link established with #{ident}"))
      end
    end

  end

end
