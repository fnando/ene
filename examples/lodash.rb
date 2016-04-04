require_relative "boot"
package = Ene::Package.new(source: "lodash", version: "4.6.1")
package.export_to "#{__dir__}/server/gems"
