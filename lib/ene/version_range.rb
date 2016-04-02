module Ene
  class VersionRange
    InvalidVersionError = Class.new(StandardError)

    def self.parse(version)
      new(version).parse
    end

    attr_reader :version

    def initialize(version)
      @version = version
    end

    def parse
      case version
      when /\A(.*?) *- *(.*?)\z/
        Range.parse(version)
      when "*", "", /\A([\^~=]|<=?|>=?)?x(?:\.(\d+|x)(\.(\d+|x))?)?\z/
        case version
        when /\A(>|<)x/
          ["<0.0.0"]
        else
          [">=0.0.0"]
        end
      when /\A(>=?|<=?)((\d+|x)(\.\d+|x){0,2})\z/
        v1 = Version.parse($2)
        ["#{$1}#{v1}"]
      when /\A([><=~^\d.x]+) ([><=~^\d.x]+)\z/
        v1 = VersionRange.parse($1)
        v2 = VersionRange.parse($2)

        [v1.first, v2.first]
      when /\A[=v]?((\d+|x)(\.\d+|x){0,2})\z/
        v1 = Version.parse($1)
        v2 = if v1.components.size == 1
               Version.new(v1.major + 1, 0, 0)
             elsif v1.components.size == 2
               Version.new(v1.major, v1.minor + 1, 0)
             else
              nil
             end
        v2 ? [">=#{v1}", "<#{v2}"] : [v1.to_s]
      when /\A\^((?:\d+|x)(?:\.(?:\d+|x)(?:\.(?:\d+|x))?)?)\z/
        CaretRange.parse($1)
      when /\A~(\d+(?:\.\d+(?:\.\d+)?)?)\z/
        TildeRange.parse($1)
      when /\A\d+\.(?:(?:\d+|x)(?:\.(?:\d+|x))?)?\z/
        XRange.parse(version)
      else
        fail InvalidVersionError, "#{version.inspect} is invalid."
      end
    end
  end
end
