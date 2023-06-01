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

class Player
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end

  def get_spot(board)
    spot = nil
    loop do
      puts 'Enter [0-8]:'
      spot = gets.chomp.to_i
      if spot >= 0 && spot <= 8 && board.available_spaces.include?(spot.to_s)
        board.mark_spot(spot, @marker)
        break
      else
        puts 'Invalid input. Please enter a number between 0 and 8 that has not already been taken.'
      end
    end
  end
end

class ComputerPlayer
  attr_reader :marker, :difficulty

  def initialize(marker, difficulty)
    @marker = marker
    @difficulty = difficulty
  end

  def get_spot(board)
    spot = nil
    starting_spot = @difficulty == 'hard' ? '4' : '2'
    loop do
      if board.available_spaces.include?(starting_spot)
        spot = starting_spot.to_i
        board.mark_spot(spot, @marker)
        break
      else
        spot = get_best_move(board)
        if board.available_spaces.include?(spot.to_s)
          board.mark_spot(spot, @marker)
          break
        end
      end
    end
    spot
  end

  private

  def get_best_move(board)
    available_spaces = board.available_spaces
    other_marker = @marker == 'x' ? '■'.green : 'x'.pink

    # Check if there's an immediate win or block opportunity
    available_spaces.each do |as|
      board.mark_spot(as.to_i, @marker)
      if board.game_is_over?
        board.mark_spot(as.to_i, as)
        return as.to_i
      else
        board.mark_spot(as.to_i, other_marker)
        if board.game_is_over?
          board.mark_spot(as.to_i, as)
          return as.to_i
        else
          board.mark_spot(as.to_i, as)
        end
      end
    end

    # Look ahead and try to predict player's moves
    if @difficulty == :hard
      corners = %w[1 3 7 9]
      edges = %w[2 4 6 8]
      best_move = nil
      corners.each do |corner|
        next unless available_spaces.include?(corner)

        board.mark_spot(corner.to_i, @marker)
        if board.get_best_move(other_marker) > 0
          best_move = corner.to_i
          board.mark_spot(corner.to_i, as)
          break
        else
          board.mark_spot(corner.to_i, as)
        end
      end
      if best_move.nil?
        edges.each do |edge|
          next unless available_spaces.include?(edge)

          board.mark_spot(edge.to_i, @marker)
          if board.get_best_move(other_marker) > 0
            best_move = edge.to_i
            board.mark_spot(edge.to_i, as)
            break
          else
            board.mark_spot(edge.to_i, as)
          end
        end
      end
      return best_move.to_i if best_move
    end

    # Otherwise, choose a random available space
    available_spaces.sample.to_i
  end
end
