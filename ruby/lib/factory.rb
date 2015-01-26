
module Coul
  module Factory

    def self.build_pong
      header + "PONG\n\n"
    end

    def self.build_ping
      header + "PING\n\n"
    end

    def self.build_smsg(nick, server, channel, timestamp, message)
      "#{header}SMSG #{nick}@#{server} #{channel} #{timestamp}\n#{message}\n"
    end

    def self.build_msg(channel, message)
      "#{header}MSG #{channel}\n#{message}\n\n"
    end

    def self.build_alert(source, timestamp, message)
      if source == :server
        source = "SERVER"
      elsif source == :network
        source = "NETWORK"
      else
        raise ArgumentError, "source needs to be :server or :network"
      end
      "#{header}ALERT #{source} #{timestamp}\n#{message}\n"
    end


    private

    def self.header
      "COUL " + VERSION + " "
    end

  end
end
