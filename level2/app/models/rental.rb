include JsonInterface

class Rental
  attr_reader :id
  attr_reader :car
  attr_reader :start_date
  attr_reader :end_date
  attr_reader :distance
  attr_reader :price
  attr_reader :test_object

  def initialize(id, car_id, start_date, end_date, distance, test_object = false)
    @id = id
    @car = Car.new(*JsonInterface.find_row(model_name: "cars",id: car_id, path_to_json: json_input_path).values)
    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)
    @distance = distance
    @test_object = test_object

    duration = (@end_date - @start_date).to_i + 1
    @price = (@car.price_per_km  * @distance) + set_time_price
  end

  def self.find_collection
    rental_rows = JsonInterface.parse_collection(model_name: "rentals", path_to_json: "data/input.json")
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

  def reduction(days_count)
    case days_count
    when (1..3)
      0.1
    when (4..9)
      0.3
    when (10..)
      0.5
    else
      0
    end
  end

  def set_time_price
    time_price = 0
    days_count = 0
    (@start_date..@end_date).each do |date|
      time_price += (@car.price_per_day * (1 - reduction(days_count))).truncate
      days_count += 1
    end
    return time_price
  end

  def json_input_path
    test_object ?  "specs/fixtures/input.json" : "data/input.json"
  end
end






