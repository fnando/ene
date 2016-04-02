module Ene
  class VersionRange
    class Range
      def self.parse(version)
        new(version).parse
      end

      attr_reader :version

      def initialize(version)
        @version = version
      end

      def parse
        v1, v2 = version.split(/\s*-\s*/)
        v1 = Version.parse(v1)
        v2 = Version.parse(v2)

        if v2.components.size == 1
          v2 = Version.new(v2.major + 1, 0, 0)
          operator = "<"
        elsif v2.components.size == 2
          v2 = Version.new(v2.major, v2.minor + 1, 0)
          operator = "<"
        else
          operator = "<="
        end

        [">=#{v1}", "#{operator}#{v2}"]
      end
    end
  end
end
