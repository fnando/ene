module Ene
  class Package
    module Source
      class Registry
        def self.match?(source)
          source =~ /\A((@[-a-z0-9_]+\/)?[-a-z0-9_]+)\z/i
        end

        def self.fetch(**keys, &block)
          new(**keys).fetch(&block)
        end

        attr_reader :source
        attr_reader :version
        attr_reader :registry

        def initialize(source:, version:, registry:)
          @source = source
          @version = version
          @registry = registry
        end

        def fetch(&block)
          tmp_dir = Dir.mktmpdir
          tarball = fetch_tarball_url
          response = Aitch.get(tarball)
          tarball_path = File.join(tmp_dir, "package.tgz")
          File.open(tarball_path, "wb") {|file| file << response.body }
          extract_tarball(tmp_dir, tarball_path)

          package_dir = File.join(tmp_dir, "package")

          yield package_dir, Manifest.load(File.join(package_dir, "package.json"))
        end

        def extract_tarball(base_dir, tarball_path)
          Gem::Package::TarReader.new(Zlib::GzipReader.open(tarball_path)) do |tar|
            tar.each do |entry|
              path = File.join(base_dir, entry.full_name)

              if entry.file?
                FileUtils.mkdir_p(File.dirname(path))
                File.open(path, "wb") {|file| file << entry.read }
              elsif entry.directory?
                FileUtils.mkdir_p(path)
              end
            end
          end
        end

        def fetch_tarball_url
          info = Aitch.get(File.join(registry, URI.escape(source))).data
          versions = info["versions"].keys
          versions = versions.reject {|v| v =~ /[a-z]/ }.sort
          v = find_version(version, versions)
          info["versions"].fetch(v)["dist"]["tarball"]
        end

        def find_version(version, available_versions)
          return version if available_versions.include?(version)
          return available_versions.last unless version

          available_versions = available_versions.select do |v|
            Gem::Requirement.create(VersionRange.parse(version)).satisfied_by?(Gem::Version.create(v))
          end

          available_versions.last
        end
      end
    end
  end
end
