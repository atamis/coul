
module Coul
  module Factory

    def build_pong
      header + "PONG\n\n"
    end

    def build_ping
      header + "PING\n\n"
    end

    def build_smsg(nick, server, channel, timestamp, message)
      "#{header}SMSG #{nick}@#{server} #{channel} #{timestamp}\n#{message}\n"
    end


    private

    def header
      "COUL " + VERSION + " "
    end

  end
end
