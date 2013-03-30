require 'sinatra/base'
require 'json'
require 'nokogiri'

class Toronto < Sinatra::Base

  get "/" do
    @index ||= File.read(File.join("public", "index.html"))
  end

  get "/parks" do
    content_type :json
    doc = Nokogiri::XML(File.read(File.join("resources", "locations-20110725.xml")))
    doc.remove_namespaces!
    leash_free_areas = doc.xpath("//FacilityType[.='Leash-Free Area']")
    response = {:total => leash_free_areas.count, :locations => []}
    leash_free_areas.each do |facility_type|
      location_xml = facility_type.parent.parent.parent
      response[:locations] << Location.new(location_xml.xpath(".//LocationID").text, location_xml.xpath(".//LocationName").text, location_xml.xpath(".//Address").text, location_xml.xpath(".//PostalCode").text)
    end
    response.to_json
  end

end

class Location
  attr_reader :id, :name, :address, :postal_code

  def initialize(id, name, address, postal_code)
    @id = id
    @name = name
    @address = address
    @postal_code = postal_code
  end

  def to_json(options)
    { "id" => id, "name" => name, "address" => address, "postalCode" => postal_code }.to_json
  end
end

