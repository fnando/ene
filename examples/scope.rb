$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "bundler/setup"
require "ene"

package = Ene::Package.new(source: "@fnando/test")
package.export_to "#{__dir__}/server/gems"