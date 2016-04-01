module Ene
  class Version
    def self.parse(version)
      new(version)
    end

    def self.from_components(components)
      case components.size
      when 0
        new(0, 0, 0)
      when 1
        new(*components, 0, 0)
      when 2
        new(*components, 0)
      else
        new(*components)
      end
    end

    attr_reader :raw, :major, :minor, :patch, :components

    def initialize(*args)
      if args.first.kind_of?(String)
        version = args.first
        @raw = version
      else
        @major, @minor, @patch = args
        @components = args
        return
      end

      @components = version.split(".")
      @major, @minor, @patch = parse(version).map(&:to_i)
      @major ||= 0
      @minor ||= 0
      @patch ||= 0

      if components[0] == "x"
        @major = 0
        @minor = 0
        @patch = 0
      elsif components[1] == "x"
        @minor = 0
        @patch = 0
      elsif components[2] == "x"
        @patch = 0
      end
    end

    def to_s
      [major, minor, patch].join(".")
    end

    def parse(version)
      components = version
                    .gsub(/[^.\d]/m, "")
                    .split(".")
    end

    def set(component, value)
      iname = :"@#{component}"
      instance_variable_set iname, value
    end

    def increment(component)
      iname = :"@#{component}"
      set component, instance_variable_get(iname) + 1
    end

    def reset(component)
      set component, 0
    end
  end

  class VersionRange
    InvalidVersionError = Class.new(StandardError)

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

    class XRange
      def self.parse(version)
        new(version).parse
      end

      attr_reader :version

      def initialize(version)
        @version = version
      end

      def parse
        v1 = Version.parse(version)

        v2 = if v1.components[1] == "x"
               Version.new(v1.major + 1, 0, 0)
             elsif v1.components[2] == "x"
               Version.new(v1.major, v1.minor + 1, 0)
             end

        [">=#{v1}", "<#{v2}"]
      end
    end

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

    class TildeRange
      def self.parse(version)
        new(version).parse
      end

      attr_reader :version

      def initialize(version)
        @version = version
      end

      def parse
        v1 = Version.parse(version)

        v2 = if v1.components.size >= 2
               Version.new(v1.major, v1.minor + 1, 0)
             elsif v1.components.size == 1
               v1.major.zero? ? Version.new(1, 0, 0) :
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
