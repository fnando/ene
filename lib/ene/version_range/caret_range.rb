module Ene
  class VersionRange
    class CaretRange
      def self.parse(version)
        new(version).parse
      end

      attr_reader :version

      def initialize(version)
        @version = version
      end

      def parse
        v1 = Version.parse(version)

        v2 = if v1.components.size == 1
               v1.major.zero? ? Version.new(v1.major + 1, 0, 0) :
                                Version.new(v1.major + 1, 0, 0)
             elsif v1.components.size == 2
               v1.major.zero? ? Version.new(0, v1.minor + 1, 0) :
                                Version.new(v1.major + 1, 0, 0)
             elsif v1.components.size == 3
               v1.major.zero? ? Version.new(v1.major, v1.minor + 1, 0) :
                                Version.new(v1.major + 1, 0, 0)
             end

        v2 = if v1.components.size == 2 && v1.components[1] == "x"
               Version.new(v1.major + 1, 0, 0)
             else
              v2
             end

        [">=#{v1}", "<#{v2}"]
      end
    end
  end
end
