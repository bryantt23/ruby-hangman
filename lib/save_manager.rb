require "json"

class SaveManager
  def self.save_game(hash, file)
    json_string = hash.to_json
    File.open(file, "w") do |f|
      f.write(json_string)
    end
  end

  def self.load_game(file)
    content = File.read(file)
    data = JSON.parse(content, symbolize_names: true)

    # Normalize status back to a symbol
    if data[:status].is_a?(String)
      data[:status] = data[:status].to_sym
    end
    data
  end
end
