module Ene
  class GemIndex
    def self.update(dir)
      indexer = Gem::Indexer.new(dir)

      if File.exist?("#{dir}/specs.4.8")
        indexer.update_index
      else
        indexer.generate_index
      end
    end
  end
end
