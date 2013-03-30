require 'json'

Park = Struct.new(:id, :name, :address, :postal_code, :latitude, :longitude) do
  def to_json(options)
    {
      :id => id,
      :name => name,
      :address => address,
      :postalCode => postal_code,
      :latitude => latitude,
      :longitude => longitude
    }.to_json
  end
end

