include JsonInterface

class Car
  attr_reader :id
  attr_reader :price_per_day
  attr_reader :price_per_km

  def initialize(id, price_per_day, price_per_km)
    @id = id
    @price_per_day = price_per_day
    @price_per_km = price_per_km
  end
end
