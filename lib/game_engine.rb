require_relative "game_state"
require_relative "view"
require_relative "save_manager"

class GameEngine
  MIN_WORD_LENGTH = 1
  MAX_WORD_LENGTH = 2
  SAVE_DIR = File.join(__dir__, "..", "saves")

  def initialize
    @view = View.new
    @file_name = nil
  end

  def get_word
    file = File.open("google-10000-english-no-swears.txt", "r")
    lines = file.readlines
    words = lines.map { |word| word.chomp }.select { |word| word.length >= MIN_WORD_LENGTH && word.length <= MAX_WORD_LENGTH }
    words.sample
  end

  def start
    keep_playing = true
    while keep_playing
      welcome
      # play_game
      keep_playing = play_again?
    end
  end

  def valid_selection?(input, filenames)
    return false unless input.match?(/^\d+$/)   # digits only
    index = input.to_i
    index >= 1 && index <= filenames.length
  end

  def welcome
    puts @view.show_welcome

    loop do
      filenames = Dir.children(SAVE_DIR)
      puts @view.show_new_game_saved_games(filenames)
      input = gets.chomp
      if input.downcase == "n"
        play_game(nil)
      else
        unless valid_selection?(input, filenames)
          puts @view.invalid_selection
        else
          file_to_load = filenames[input.to_i - 1]
          game_state_hash = SaveManager.load_game("#{SAVE_DIR}/#{file_to_load}")
          game_state = GameState.from_saved_state(game_state_hash)
          @file_name = file_to_load
          play_game(game_state)
        end
      end
    end
  end

  def play_game(game_state)
    if game_state == nil
      @word = get_word
      game_state = GameState.new(@word)
    end
    puts "The word is #{game_state.get_game_state[:word]}"

    puts "game state is #{game_state.get_game_state}"

    while game_state.get_game_state[:status] == :in_progress
      puts @view.show_game_state(game_state.get_game_state)
      puts @view.show_guess_letter_or_save
      input = gets.chomp.downcase
      if input == "save"
        Dir.mkdir(SAVE_DIR) unless Dir.exist?(SAVE_DIR)
        file_path = File.join(SAVE_DIR, "#{Time.now.strftime("%Y-%m-%d-%H-%M-%S")}.json")
        SaveManager.save_game(game_state.get_game_state, file_path)
        return
      end
      guess_result = game_state.guess_letter(input)
      puts @view.show_guess_feedback(guess_result)
      puts "The game state is #{game_state.get_game_state}"
    end

    puts @view.show_win_loss(game_state.get_game_state[:status])
    if @file_name
      file_path = File.join(SAVE_DIR, @file_name)
      File.delete(file_path) if File.exist?(file_path)
      @file_name = nil
    end
  end

  def play_again?
    puts @view.show_replay_prompt
    while user_input = gets.chomp
      case user_input
      when "X", "x"
        return false
      when ""
        return true
      else
        puts @view.show_replay_prompt
      end
    end
  end
end

g = GameEngine.new
g.start
