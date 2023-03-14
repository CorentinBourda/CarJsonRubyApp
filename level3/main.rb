require_relative 'initialize.rb'
include JsonInterface

Rental.export_attributes_as_json({id: "id", price: "price", commission_hash: "commission"})
