require_relative "boot"
package = Ene::Package.new(source: "sinon")
package.export_to "#{__dir__}/server/gems"
