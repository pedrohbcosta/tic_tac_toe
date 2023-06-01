require_relative 'colorize'

class Board
  attr_reader :board

  def initialize
    @board = ('0'..'8').to_a
  end

  def display_board
    system 'clear'
    puts "Player 1 #{'■'.green}. The Player 2 is #{'x'.pink}.\n\n"
    puts " #{@board[0]} | #{@board[1]} | #{@board[2]} \n===+===+===\n #{@board[3]} | #{@board[4]} | #{@board[5]} \n===+===+===\n #{@board[6]} | #{@board[7]} | #{@board[8]} \n\n"
  end

  def mark_spot(spot, marker)
    @board[spot] = marker
  end

  def available_spaces
    @board.filter { |s| s != 'x'.pink && s != '■'.green }
  end

  def game_is_over?
    winning_combinations.any? { |combo| combo.uniq.length == 1 } || tie?
  end

  def tie?
    available_spaces.empty?
  end

  private

  def winning_combinations
    [
      [@board[0], @board[1], @board[2]],
      [@board[3], @board[4], @board[5]],
      [@board[6], @board[7], @board[8]],
      [@board[0], @board[3], @board[6]],
      [@board[1], @board[4], @board[7]],
      [@board[2], @board[5], @board[8]],
      [@board[0], @board[4], @board[8]],
      [@board[2], @board[4], @board[6]]
    ]
  end
end