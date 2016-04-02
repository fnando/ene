module Ene
  class Package
    module Source
      def self.find(source)
        adapters.find {|adapter| adapter.match?(source) }
      end

      def self.adapters
        constants.map {|name| const_get(name) }
      end
    end
  end
end
