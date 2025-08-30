require "game_state"

RSpec.describe GameState do
  describe "#initialize" do
    it "sets up a new game with given word and default values" do
      state = GameState.new("test")
      snapshot = state.get_game_state

      expect(snapshot[:word]).to eq("test")
      expect(snapshot[:word_display]).to eq("_ _ _ _")
      expect(snapshot[:remaining_guesses]).to eq(6)
      expect(snapshot[:correct_guesses]).to eq([])
      expect(snapshot[:incorrect_guesses]).to eq([])
      expect(snapshot[:status]).to eq(:in_progress)
      expect(snapshot[:created_at]).to be_a(Time)
      expect(snapshot[:updated_at]).to be_a(Time)
      expect(snapshot[:created_at]).to eq(snapshot[:updated_at])
    end
  end

  describe "#guess_letter" do
    before(:each) do
      @state = GameState.new("test")
    end

    it "returns :correct and updates state when guess is in the word" do
      result = @state.guess_letter("t")
      expect(result).to eq(:correct)
      snapshot = @state.get_game_state
      expect(snapshot[:correct_guesses]).to include("t")
      expect(snapshot[:remaining_guesses]).to eq(6)
      expect(snapshot[:word_display]).to eq("t _ _ t")
      expect(snapshot[:status]).to eq(:in_progress)
    end

    it "returns :incorrect and decreases remaining guesses when guess is wrong" do
      result = @state.guess_letter("x")
      expect(result).to eq(:incorrect)
      snapshot = @state.get_game_state
      expect(snapshot[:incorrect_guesses]).to include("x")
      expect(snapshot[:remaining_guesses]).to eq(5)
      expect(snapshot[:word_display]).to eq("_ _ _ _")
      expect(snapshot[:status]).to eq(:in_progress)
    end

    it "returns :duplicate when the same correct letter is guessed again" do
      @state.guess_letter("t")
      result = @state.guess_letter("t")
      expect(result).to eq(:duplicate)
      snapshot = @state.get_game_state
      expect(snapshot[:status]).to eq(:in_progress)
    end

    it "returns :duplicate when the same incorrect letter is guessed again" do
      @state.guess_letter("x")
      result = @state.guess_letter("x")
      expect(result).to eq(:duplicate)
      snapshot = @state.get_game_state
      expect(snapshot[:status]).to eq(:in_progress)
    end

    it "returns :invalid for non-letter input" do
      result = @state.guess_letter("1")
      expect(result).to eq(:invalid)
      snapshot = @state.get_game_state
      expect(snapshot[:status]).to eq(:in_progress)
    end
  end

  describe "#get_game_state" do
    before(:each) do
      @state = GameState.new("test")
    end

    it "returns the correct snapshot after some guesses" do
      @state.guess_letter("t")
      @state.guess_letter("x")
      snapshot = @state.get_game_state

      expect(snapshot[:correct_guesses]).to include("t")
      expect(snapshot[:incorrect_guesses]).to include("x")
      expect(snapshot[:remaining_guesses]).to eq(5)
      expect(snapshot[:word_display]).to eq("t _ _ t")
      expect(snapshot[:status]).to eq(:in_progress)
    end
  end

  describe "win and loss conditions" do
    it "reports win when all letters are guessed" do
      state = GameState.new("cat")
      state.guess_letter("c")
      state.guess_letter("a")
      state.guess_letter("t")
      snapshot = state.get_game_state
      expect(snapshot[:status]).to eq(:win)
      expect(snapshot[:word_display]).to eq("c a t")
    end

    it "reports loss when wrong guesses equal limit" do
      state = GameState.new("dog")
      state.guess_letter("x")
      state.guess_letter("y")
      state.guess_letter("z")
      state.guess_letter("q")
      state.guess_letter("w")
      state.guess_letter("e")
      snapshot = state.get_game_state
      expect(snapshot[:status]).to eq(:loss)
      expect(snapshot[:word_display]).to eq("_ _ _")
    end
  end
  describe ".from_saved_state" do
    it "restores a GameState from a saved hash" do
      saved = {
        word: "test",
        remaining_guesses: 4,
        correct_guesses: ["t", "e"],
        incorrect_guesses: ["x", "y"],
        created_at: Time.now - 60,
        updated_at: Time.now,
        word_display_data_structure: ["t", "e", "_", "t"],
        word_display: "t e _ t",
        status: :in_progress,
      }

      state = GameState.from_saved_state(saved)
      snapshot = state.get_game_state

      expect(snapshot[:word]).to eq("test")
      expect(snapshot[:remaining_guesses]).to eq(4)
      expect(snapshot[:correct_guesses]).to eq(["t", "e"])
      expect(snapshot[:incorrect_guesses]).to eq(["x", "y"])
      expect(snapshot[:word_display]).to eq("t e _ t")
      expect(snapshot[:status]).to eq(:in_progress)
    end
  end
end
