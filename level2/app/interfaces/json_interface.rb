module JsonInterface
  def find_row(model_name:, id:, path_to_json:)
    data_json = parse_input_json_file(path_to_json)
    return nil unless (model_rows = data_json[model_name])
    model_rows.each do |model_row|
      if model_row["id"] == id
        return model_row.transform_keys { |key| key.to_sym rescue key }
      end
    end
    return nil
  end

  def parse_collection(model_name:, path_to_json:)
    data_json = parse_input_json_file(path_to_json)
    return nil unless (model_rows = data_json[model_name])
    return row_collection = model_rows.map { |model_row| model_row.transform_keys { |key| key.to_sym rescue key } }
  end

  def export_hash(hash)
    path = "data/output.json"
    File.open(path,"w") do |f|
      f.write(JSON.pretty_generate(hash))
    end
  end

  private

  def parse_input_json_file(path_to_json)
    file = File.open(path_to_json)

    json_string = file.read
    return json_hash = JSON.parse(json_string)
  end
end
