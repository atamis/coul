require 'factory'

module Coul
  class Engine
    include Factory
    def initialize(clients)
      @clients = clients
      @parser = Coul::Parser.new
    end

    def client_process(source, message)
      parsed = @parser.parse(message)
      case parsed[:command]
      when "PING"
        ping(source)
      end
    end

    def ping(source)
      source.send(build_pong)
    end

  end

end
