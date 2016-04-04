module Ene
  class Package
    DEFAULT_REGISTRY = "https://registry.npmjs.com".freeze

    attr_reader :source
    attr_reader :version
    attr_reader :prefix
    attr_reader :registry

    def initialize(source:, version: nil, prefix: "ene-", registry: DEFAULT_REGISTRY)
      @source = source
      @version = version
      @prefix = prefix
      @registry = registry
    end

    def copy_file(package_dir:, file:, files:, assets_dir:, gem_dir:)
      return if file.directory?

      relative_path = file.relative_path_from(Pathname.new(package_dir))

      # If there's just one file in the package, just move it to lib/assets
      # root directory, so that you can just import the file without passing
      # the directory (e.g. `//= require sinon` vs `//= require lib/sinon`).
      relative_path = Pathname.new(relative_path.basename) if files.size == 1

      target_path = File.join(assets_dir, relative_path)
      target_dir = File.join(assets_dir, relative_path.dirname)

      FileUtils.mkdir_p(gem_dir)
      FileUtils.mkdir_p(assets_dir)
      FileUtils.mkdir_p(target_dir)
      FileUtils.cp(file, target_path)
    end

    def create_railtie(gem_dir, rubygem_name, class_name, version)
      lib_dir = File.join(gem_dir, "lib")
      FileUtils.mkdir_p(lib_dir)

      File.open(File.join(lib_dir, "#{rubygem_name}.rb"), "w") do |file|
        file << <<~RUBY
          require "rails"

          module Ene
            module Gems
              module #{class_name}
                VERSION = "#{version}".freeze

                class Railtie < Rails::Railtie
                  config.assets.paths << File.join(__dir__, "assets")
                end
              end
            end
          end
        RUBY
      end
    end

    def build_gem(gem_dir, rubygem_name, manifest)
      Dir.chdir(gem_dir) do
        spec = Gem::Specification.new do |s|
          s.name        = rubygem_name
          s.version     = manifest.version
          s.licenses    = manifest.license
          s.summary     = manifest.description
          s.homepage    = manifest.homepage
          s.description = s.summary
          s.files       = Dir["./**/*"]
          s.authors     = [(manifest.author || manifest.maintainers)].flatten.compact.map do |author|
                            author.kind_of?(String) ? author : "#{author["name"]} <#{author["email"]}>"
                          end

          s.add_dependency "rails"

          (manifest.dependencies || []).each do |name, version|
            s.add_dependency "#{prefix}#{name}", VersionRange.parse(version)
          end
        end

        Gem::Package.build(spec, true)
      end
    end

    def export_to(dir)
      FileUtils.mkdir_p File.expand_path(dir)

      source_adapter = Source.find(source)
      source_adapter.fetch(source: source, version: version, registry: registry) do |package_dir, manifest|
        files = [manifest.main, manifest.files].flatten.compact

        gem_dir = File.expand_path(File.join(package_dir, "..", "gem"))
        assets_dir = File.join(gem_dir, "lib/assets")

        files.each do |pattern|
          Dir[File.join(package_dir, pattern)].each do |file|
            copy_file package_dir: package_dir,
                      file: Pathname.new(file),
                      files: files,
                      assets_dir: assets_dir,
                      gem_dir: gem_dir

          end
        end

        rubygem_name = gem_name(manifest)
        build_dependencies(dir, manifest)
        gem_class_name = class_name(manifest.name)
        create_railtie gem_dir, rubygem_name, gem_class_name, manifest.version
        gem_file_name = build_gem(gem_dir, rubygem_name, manifest)
        FileUtils.mv File.join(gem_dir, gem_file_name), dir
      end
    end

    def build_dependencies(dir, manifest)
      (manifest.dependencies || []).each do |name, version|
        Package
          .new(source: name, version: version, registry: registry, prefix: prefix)
          .export_to(dir)
      end
    end

    def gem_name(manifest)
      [prefix, manifest.name]
        .join
        .gsub(/@/, "")
        .gsub(/\//, "-")
    end

    def class_name(name)
      name
        .split(/[^a-z0-9]/)
        .map(&:capitalize)
        .join
    end
  end
end
