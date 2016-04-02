module Ene
  class Manifest < OpenStruct
    def self.load(path)
      new(JSON.load(File.read(path)))
    end
  end
end
