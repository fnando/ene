require_relative "boot"
package = Ene::Package.new(source: "@fnando/test")
package.export_to "#{__dir__}/server/gems"
