include JsonInterface

class Rental
  attr_reader :id
  attr_reader :car
  attr_reader :start_date
  attr_reader :end_date
  attr_reader :distance
  attr_reader :price

  def initialize(id, car_id, start_date, end_date, distance)
    @id = id
    @car = Car.new(*JsonInterface.find_row(model_name: "cars",id: car_id).values)
    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)
    @distance = distance

    duration = (@end_date - @start_date).to_i + 1
    @price = (@car.price_per_km  * @distance) + (@car.price_per_day * duration)
  end

  def self.find_collection
    rental_rows = JsonInterface.parse_collection(model_name: "rentals")
    rental_collection = []
    rental_rows.each do |attributes|
      rental_collection << self.new(*attributes.values)
    end
    return rental_collection
  end

  def self.export_prices_as_json
    rentals = find_collection
    hash_to_export = {"rentals" => []}

    rentals.each do |rental|
      hash_to_export["rentals"] << {"id" => rental.id, "price" => rental.price }
    end
    JsonInterface.export_hash(hash_to_export)
  end
end
