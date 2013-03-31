require 'json'
require 'nokogiri'
require './model/park'

class TorontoGateway
  def initialize(xml, coordinates_mapping)
    @xml = Nokogiri::XML(xml)
    @xml.remove_namespaces!
    @coordinates_mapping = JSON.parse(coordinates_mapping)["mappings"]
  end

  def dog_parks
    @parks ||= leash_free_areas.map do |facility_type|
      location_xml = facility_type.parent.parent.parent
      id = location_xml.xpath(".//LocationID").text
      name = location_xml.xpath(".//LocationName").text
      address = location_xml.xpath(".//Address").text
      postal_code = location_xml.xpath(".//PostalCode").text
      mapping = @coordinates_mapping.detect { |m| m["locationId"] == id }
      Park.new(id, name, address, postal_code, mapping["latitude"], mapping["longitude"])
    end.uniq
  end

  def find_park(park_id)
    dog_parks.detect { |p| p.id == park_id }
  end

  private
  def leash_free_areas
    @leash_free ||= @xml.xpath("//FacilityType[.='Leash-Free Area']")
  end
end

