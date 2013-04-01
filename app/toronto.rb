require 'sinatra/base'
require 'json'
require 'oauth'
require 'uri'

class Toronto < Sinatra::Base

  def initialize(gateway)
    super
    @gateway = gateway
  end

  get "/parks" do
    content_type :json
    {:locations => @gateway.dog_parks, :total => @gateway.dog_parks.count }.to_json
  end

  get "/parks/:id/ratings" do
    content_type :json
    park = @gateway.find_park(params[:id])
    if park.nil?
      status 404
    else
      consumer = OAuth::Consumer.new(ENV["YELP_CONSUMER_KEY"], ENV["YELP_CONSUMER_SECRET"], {:site => "http://api.yelp.com"})
      access_token = OAuth::AccessToken.new(consumer, ENV["YELP_TOKEN"], ENV["YELP_TOKEN_SECRET"])
      access_token.get("/v2/search?term=#{URI::encode(park.name)}&category_filter=parks&limit=10&ll=#{park.latitude},#{park.longitude}").body
    end
  end

end
