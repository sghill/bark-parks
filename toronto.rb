require 'sinatra/base'
require 'json'

class Toronto < Sinatra::Base

  def initialize(gateway)
    super
    @gateway = gateway
  end

  get "/" do
    @index ||= File.read(File.join("public", "index.html"))
  end

  get "/parks" do
    content_type :json
    {:locations => @gateway.dog_parks, :total => @gateway.dog_parks.count }.to_json
  end

end
