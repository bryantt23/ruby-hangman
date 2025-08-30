require_relative "game_state"
require_relative "view"
require_relative "save_manager"

class GameEngine
  MIN_WORD_LENGTH = 1
  MAX_WORD_LENGTH = 2

  def initialize
    @view = View.new
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
      # welcome
      play_game
      keep_playing = play_again?
    end
  end

  def welcome
    puts @view.show_welcome
    filenames = Dir.entries("saves")
    # saved_games=
    #
    #
    #
    puts @view.show_new_game_saved_games()
  end

  def play_game
    @word = get_word
    puts "The word is #{@word}"
    game_state = GameState.new(@word)

    while game_state.get_game_state[:status] == :in_progress
      puts @view.show_game_state(game_state.get_game_state)
      puts @view.show_guess_letter_or_save
      input = gets.chomp.downcase
      if input == "save"
        save_dir = File.join(__dir__, "..", "saves")
        Dir.mkdir(save_dir) unless Dir.exist?(save_dir)
        file_path = File.join(save_dir, "#{Time.now.strftime("%Y-%m-%d-%H-%M-%S")}.json")
        SaveManager.save_game(game_state.get_game_state, file_path)
        return
      end
      guess_result = game_state.guess_letter(input)
      @view.show_guess_feedback(guess_result)
      puts "The game state is #{game_state.get_game_state}"
    end

    puts @view.show_win_loss(game_state.get_game_state[:status])
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
