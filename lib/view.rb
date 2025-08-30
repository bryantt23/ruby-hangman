class View
  MESSAGES = {
    correct: "Correct guess!",
    incorrect: "Incorrect guess.",
    invalid: "Please enter a valid single letter.",
    duplicate: "You already guessed that letter.",
  }

  def show_welcome
    "Welcome to Hangman!"
  end

  def show_win_loss(result)
    result == :win ? "You win!" : "You have lost :("
  end

  def show_replay_prompt
    "Press Enter to play again or X to exit"
  end

  def show_guess_letter_or_save
    "Enter your guess or type 'Save' to save & exit"
  end

  def show_guess_feedback(result)
    MESSAGES[result] || "Fail"
  end

  def show_new_game_saved_games(saved_games)
    if saved_games.empty?
      "(N)ew game (no saved games available)"
    else
      lines = ["(N)ew game or choose a saved game"]
      saved_games.each_with_index do |value, index|
        lines.push("#{index + 1}. #{value}")
      end
      lines.join("\n")
    end
  end

  def show_game_state(state)
    ["Guesses remaining: #{state[:remaining_guesses]}", "Current word: #{state[:word_display]}", "Incorrect guesses: #{state[:incorrect_guesses].sort.join(", ")}"].join("\n")
  end

  def invalid_selection
    "Invalid selection"
  end
end
