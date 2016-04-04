require_relative "boot"

package = Ene::Package.new(source: "jquery")
package.export_to "#{__dir__}/server/gems"
