$LOAD_PATH << "./app"

require 'toronto'
require 'gateways/toronto_gateway'

app = Rack::Builder.new do
  map "/" do
    use Rack::Static, :urls => ["/css", "/js"], :root => "public"
    run Rack::File.new("public/index.html")
  end

  map "/api" do
    toronto_locations = File.read(File.join("resources", "locations-20110725.xml"))
    toronto_coordinates = File.read(File.join("resources", "toronto-coordinates.json"))

    run Toronto.new(TorontoGateway.new(toronto_locations, toronto_coordinates))
  end
end

run app

