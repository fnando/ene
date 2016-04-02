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
end
