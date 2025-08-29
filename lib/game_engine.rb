require_relative "game_state"
require_relative "view"
require_relative "save_manager"

class GameEngine
  def get_word
    file = File.open("google-10000-english-no-swears.txt", "r")
    lines = file.readlines
    words = lines.map { |word| word.chomp }.select { |word| word.length >= 5 && word.length <= 12 }
    words.sample
  end

  def start
    puts get_word
  end
end

g = GameEngine.new
g.start
