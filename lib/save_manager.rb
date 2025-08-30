require "json"

class SaveManager
  def self.save_game(hash, file)
    json_string = hash.to_json
    File.open(file, "w") do |f|
      f.write(json_string)
    end
  end

  def self.load_game(file)
    file = File.read(file)
    parsed_data = JSON.parse(file, symbolize_names: true)
    parsed_data
  end
end
