require "game_state"

RSpec.describe GameState do
  describe "#initialize" do
    it "sets up a new game with given word and default values" do
      state = GameState.new("test")
      snapshot = state.get_game_state

      expect(snapshot[:word]).to eq("test")
      expect(snapshot[:remaining_guesses]).to eq(6)
      expect(snapshot[:correct_guesses]).to eq([])
      expect(snapshot[:incorrect_guesses]).to eq([])
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
    end

    xit "returns :incorrect and decreases remaining guesses when guess is wrong" do
      result = @state.guess_letter("x")
      expect(result).to eq(:incorrect)
      snapshot = @state.get_game_state
      expect(snapshot[:incorrect_guesses]).to include("x")
      expect(snapshot[:remaining_guesses]).to eq(5)
    end

    xit "returns :duplicate when the same letter is guessed again" do
      @state.guess_letter("t")
      result = @state.guess_letter("t")
      expect(result).to eq(:duplicate)
    end

    xit "returns :invalid for non-letter input" do
      result = @state.guess_letter("1")
      expect(result).to eq(:invalid)
    end
  end

  describe "#get_game_state" do
    before(:each) do
      @state = GameState.new("test")
    end

    xit "returns the correct snapshot after some guesses" do
      @state.guess_letter("t")
      @state.guess_letter("x")
      snapshot = @state.get_game_state

      expect(snapshot[:correct_guesses]).to include("t")
      expect(snapshot[:incorrect_guesses]).to include("x")
      expect(snapshot[:remaining_guesses]).to eq(5)
    end
  end

  describe "win and loss conditions" do
    xit "reports win when all letters are guessed" do
      state = GameState.new("cat")
      state.guess_letter("c")
      state.guess_letter("a")
      state.guess_letter("t")
      snapshot = state.get_game_state
      expect(snapshot[:status]).to eq(:win)
    end

    xit "reports loss when wrong guesses equal limit" do
      state = GameState.new("dog")
      state.guess_letter("x")
      state.guess_letter("y")
      state.guess_letter("z")
      snapshot = state.get_game_state
      expect(snapshot[:status]).to eq(:loss)
    end
  end
end
