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

    @price = (@car.price_per_km  * @distance) + set_time_price
  end

  def self.find_collection
    JsonInterface
        .parse_collection(model_name: "rentals")
        .map { |attributes| self.new(*attributes.values) }
  end

  def commission_hash
    commission = (price * 0.3).truncate
    insurance_fee = (commission / 2.0).truncate
    assistance_fee = duration * 100
    drivy_fee = commission - insurance_fee - assistance_fee

    commission_hash = {
      "insurance_fee" => insurance_fee,
      "assistance_fee" => assistance_fee,
      "drivy_fee" => drivy_fee
    }
  end

  def linked_creditor(commission_name)
    commission_name.match(/(.*)_fee/)[1]
  end

  def actions_array
    actions_array = []
    actions_array << {
      "who": "driver",
      "type": "debit",
      "amount": price
    }
    actions_array << {
      "who": "owner",
      "type": "credit",
      "amount": (price * 0.7).truncate
    }
    commission_hash.each do |commission_name, commission|
      actions_array << {
        "who": linked_creditor(commission_name),
        "type": "credit",
        "amount": commission
      }
    end
    return actions_array
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

  def duration
    (@end_date - @start_date).to_i + 1
  end

  def set_time_price
    (@start_date..@end_date).each_with_index.reduce(0) do |time_price, (date, days_count)|
      time_price += (@car.price_per_day * (1 - reduction(days_count))).truncate
    end
  end
end






