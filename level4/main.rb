require_relative 'initialize.rb'
include JsonInterface
ENV["car_app_context"] = "production"

def export_rental_attributes_as_json(attributes_recap)
  rentals = Rental.find_collection
  hash_to_export = {"rentals" => []}

  rentals.each do |rental|
    current_rental_hash = {}
    attributes_recap.each do |attribute_method, attribute_name|
      current_rental_hash[attribute_name] = rental.send(attribute_method)
    end
    hash_to_export["rentals"] << current_rental_hash
  end
  JsonInterface.export_hash(hash_to_export)
end
export_rental_attributes_as_json({id: "id", actions_array: "actions"})
