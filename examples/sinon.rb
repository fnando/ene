$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "bundler/setup"
require "ene"

package = Ene::Package.new(source: "sinon")
package.export_to __dir__
