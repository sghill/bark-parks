require './toronto'
require './gateways/toronto_gateway'

toronto_locations = File.read(File.join("resources", "locations-20110725.xml"))
toronto_coordinates = File.read(File.join("resources", "toronto-coordinates.json"))

run Toronto.new(TorontoGateway.new(toronto_locations, toronto_coordinates))

