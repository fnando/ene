$LOAD_PATH.unshift File.join(__dir__, "lib")
require "./lib/ene"

Gem::Specification.new do |spec|
  spec.name          = "ene"
  spec.version       = Ene::VERSION
  spec.authors       = ["Nando Vieira"]
  spec.email         = ["fnando.vieira@gmail.com"]

  spec.summary       = "Convert NPM packages into Rubygems"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/fnando/ene"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject {|f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) {|f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "aitch"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-utils"
  spec.add_development_dependency "pry-meta"
end
