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
      status: :in_progress,
    }
  end

  def get_game_state
    @game_state
  end

  def guess_letter(letter)
    if !(letter =~ /[A-Za-z]/)
      :invalid
    elsif @game_state[:word_display].include?(letter) || @game_state[:incorrect_guesses].include?(letter)
      :duplicate
    elsif @game_state[:word].include?(letter)
      @game_state[:correct_guesses] << letter
      indices = find_all_indices(letter)
      indices.each do |index|
        @game_state[:word_display_data_structure][index] = letter
      end

      @game_state[:word_display] = @game_state[:word_display_data_structure].join(" ")

      if !@game_state[:word_display_data_structure].include?("_")
        @game_state[:status] = :win
      end

      :correct
    else
      @game_state[:incorrect_guesses] << letter

      @game_state[:remaining_guesses] -= 1
      if @game_state[:remaining_guesses] == 0
        @game_state[:status] = :loss
      end
      :incorrect
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
