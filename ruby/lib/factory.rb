
module Coul
  module Factory

    def build_pong
      header + "PONG\n\n"
    end

    private

    def header
      "COUL " + VERSION + " "
    end

  end
end
