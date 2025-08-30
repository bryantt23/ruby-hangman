require "save_manager"
require "json"

RSpec.describe SaveManager do
  let(:save_file) { "test_save.json" }
  let(:game_state_hash) do
    {
      word: "test",
      remaining_guesses: 4,
      correct_guesses: ["t", "e"],
      incorrect_guesses: ["x", "y"],
      created_at: Time.now,
      updated_at: Time.now,
      word_display_data_structure: ["t", "e", "_", "t"],
      word_display: "t e _ t",
      status: :in_progress,
    }
  end

  after(:each) do
    File.delete(save_file) if File.exist?(save_file)
  end

  describe "#save_game" do
    it "writes the game state hash to a JSON file" do
      SaveManager.save_game(game_state_hash, save_file)
      expect(File).to exist(save_file)
      content = File.read(save_file)
      parsed = JSON.parse(content, symbolize_names: true)
      expect(parsed[:word]).to eq("test")
      expect(parsed[:remaining_guesses]).to eq(4)
    end
  end

  describe "#load_game" do
    it "reads the JSON file and returns a hash" do
      SaveManager.save_game(game_state_hash, save_file)
      loaded = SaveManager.load_game(save_file)
      expect(loaded[:word]).to eq("test")
      expect(loaded[:remaining_guesses]).to eq(4)
      expect(loaded[:status]).to eq("in_progress").or eq(:in_progress)
    end
  end
end
