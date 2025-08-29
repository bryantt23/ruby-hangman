class GameState
  def initialize(word)
    now = Time.now
    @game_state = {
      word: word,
      remaining_guesses: 6,
      correct_guesses: [],
      incorrect_guesses: [],
      created_at: now,
      updated_at: now,
      word_display_data_structure: Array.new(word.length, "_"),
      word_display: Array.new(word.length, "_").join(" "),
    }
  end

  def get_game_state
    @game_state
  end

  def guess_letter(letter)
    if @game_state[:word_display].include?(letter)
      :duplicate
    elsif @game_state[:word].include?(letter)
      @game_state[:correct_guesses] << letter
      indices = find_all_indices(letter)
      indices.each do |index|
        @game_state[:word_display_data_structure][index] = letter
      end

      @game_state[:word_display] = @game_state[:word_display_data_structure].join(" ")

      :correct
    end
  end

  private

  def find_all_indices(letter)
    indices = []
    @game_state[:word].each_char.each_with_index do |char, index|
      if char == letter
        indices << index
      end
    end
    indices
  end

  def get_word_display
  end
end
