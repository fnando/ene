ENV["BUNDLE_GEMFILE"] = File.expand_path("#{__dir__}/../Gemfile")
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "bundler/setup"
require "ene"
