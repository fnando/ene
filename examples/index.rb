$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "bundler/setup"
require "ene"

Ene::GemIndex.update("#{__dir__}/server")
