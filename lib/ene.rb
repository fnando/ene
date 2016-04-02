module Ene
  VERSION = "0.1.0".freeze

  require "aitch"
  require "ostruct"
  require "pathname"
  require "tmpdir"
  require "fileutils"
  require "rubygems/package"
  require "rubygems/indexer"

  require "ene/version"
  require "ene/package"
  require "ene/package/source"
  require "ene/package/source/registry"
  require "ene/manifest"
  require "ene/version_range"
  require "ene/version_range/caret_range"
  require "ene/version_range/range"
  require "ene/version_range/tilde_range"
  require "ene/version_range/x_range"
  require "ene/gem_index"
end
