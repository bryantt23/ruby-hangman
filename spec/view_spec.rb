require "view"

RSpec.describe View do
  before(:each) do
    @view = View.new
  end

  describe "#show_welcome" do
    it "returns the welcome message" do
      expect(@view.show_welcome).to eq("Welcome to Hangman!")
    end
  end

  describe "#show_win_loss" do
    it "returns victory message when passed :win" do
      expect(@view.show_win_loss(:win)).to eq("You win!")
    end

    it "returns loss message when passed :loss" do
      expect(@view.show_win_loss(:loss)).to eq("You have lost :(")
    end
  end
  describe "#show_replay_prompt" do
    it "returns the replay message" do
      expect(@view.show_replay_prompt).to eq("Press Enter to play again or X to exit")
    end
  end

  describe "#show_guess_letter_or_save" do
    it "returns the prompt message for guessing or saving" do
      expect(@view.show_guess_letter_or_save).to eq("Enter your guess or type 'Save' to save & exit")
    end
  end
  describe "#show_guess_feedback" do
    it "returns a message for a correct guess" do
      expect(@view.show_guess_feedback(:correct)).to eq("Correct guess!")
    end

    it "returns a message for an incorrect guess" do
      expect(@view.show_guess_feedback(:incorrect)).to eq("Incorrect guess.")
    end

    it "returns a message for an invalid input" do
      expect(@view.show_guess_feedback(:invalid)).to eq("Please enter a valid single letter.")
    end

    it "returns a message for a duplicate guess" do
      expect(@view.show_guess_feedback(:duplicate)).to eq("You already guessed that letter.")
    end
  end

  describe "#show_new_game_saved_games" do
    it "returns a prompt when there are no saved games" do
      expect(@view.show_new_game_saved_games([])).to eq("(N)ew game (no saved games available)")
    end

    it "returns new game option plus one saved game" do
      saves = [
        { id: 1, created_at: "2025-08-27", updated_at: "2025-08-28" },
      ]

      output = @view.show_new_game_saved_games(saves)
      expect(output).to include("(N)ew game or choose a saved game")
      expect(output).to include("1. Created: 2025-08-27, Last saved: 2025-08-28")
    end

    it "returns a list of saved games when provided" do
      saves = [
        { id: 1, created_at: "2025-08-27", updated_at: "2025-08-28" },
        { id: 2, created_at: "2025-08-26", updated_at: "2025-08-27" },
      ]

      output = @view.show_new_game_saved_games(saves)
      expect(output).to include("(N)ew game or choose a saved game")
      expect(output).to include("1. Created: 2025-08-27, Last saved: 2025-08-28")
      expect(output).to include("2. Created: 2025-08-26, Last saved: 2025-08-27")
    end
  end
  describe "#show_game_state" do
    it "displays the word with blanks and letters" do
      state = {
        word_display: "_ a _ a _",
        remaining_guesses: 6,
        incorrect_guesses: [],
      }
      output = @view.show_game_state(state)
      expect(output).to include("_ a _ a _")
    end

    it "shows remaining guesses count" do
      state = {
        word_display: "_ _ _",
        remaining_guesses: 3,
        incorrect_guesses: [],
      }
      output = @view.show_game_state(state)
      expect(output).to include("Guesses remaining: 3")
    end

    it "shows incorrect guesses when there are some" do
      state = {
        word_display: "_ _ _",
        remaining_guesses: 2,
        incorrect_guesses: ["b", "c"],
      }
      output = @view.show_game_state(state)
      expect(output).to include("Incorrect guesses: b, c")
    end

    it "shows empty incorrect guesses cleanly when none exist" do
      state = {
        word_display: "_ _ _",
        remaining_guesses: 5,
        incorrect_guesses: [],
      }
      output = @view.show_game_state(state)
      expect(output).to include("Incorrect guesses: ")
    end
  end
end
