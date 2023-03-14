module JsonInterface
  def find_row(model_name:, id:)
    data_json = parse_input_json_file
    raise "Model name cannot be found" unless (model_rows = data_json[model_name])
    model_row = model_rows.find { |model_row| model_row["id"] == id }
    if model_row
      return model_row.transform_keys { |key| key.to_sym rescue key }
    else
      raise "ID cannot be found"
    end
  end

  def parse_collection(model_name:)
    data_json = parse_input_json_file
    raise "Model name cannot be found" unless (model_rows = data_json[model_name])
    return row_collection = model_rows.map { |model_row| model_row.transform_keys { |key| key.to_sym rescue key } }
  end

  def export_hash(hash)
    path = "data/output.json"
    File.open(path,"w") do |f|
      f.write(JSON.pretty_generate(hash))
    end
  end

  private

  def parse_input_json_file
    return @json_hash if @json_hash
    file = File.open(json_input_path)

    json_string = file.read
    return @json_hash = JSON.parse(json_string)
  end

  def json_input_path
    case ENV["car_app_context"]
    when "production"
      "data/input.json"
    when "test"
      "specs/fixtures/input.json"
    end
  end
end
