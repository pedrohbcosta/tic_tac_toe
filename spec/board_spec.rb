require_relative '../game'

RSpec.describe Board do
  let(:board) { Board.new }

  describe 'when a mark is create at the board' do
    it "updates the board with the player's marker" do
      board.mark_spot(0, 'x')
      expect(board.available_spaces).to_not include('0')
    end
  end

  describe 'when there is available spaces' do
    it 'returns an array on the board' do
      board.mark_spot(0, 'x')
      expect(board.available_spaces).to eq(
        %w[x 1 2 3 4 5 6 7 8]
      )
    end
  end

  describe 'when the game is over' do
    context 'when there is a winning combination on the board' do
      it 'returns true' do
        board.mark_spot(0, 'x')
        board.mark_spot(1, 'x')
        board.mark_spot(2, 'x')
        expect(board.game_is_over?).to be true
      end
    end

    context 'when there is a tie' do
      it 'returns true' do
        board.mark_spot(0, '■')
        board.mark_spot(1, 'x')
        board.mark_spot(2, '■')
        board.mark_spot(3, 'x')
        board.mark_spot(4, 'x')
        board.mark_spot(5, '■')
        board.mark_spot(6, '■')
        board.mark_spot(7, '■')
        board.mark_spot(8, 'x')
        # RSpec doesn't works well with the colorize class I created.
        # So I'm monkey patching the available_space method.
        allow(board).to receive(:available_spaces).and_return(
          board.board.filter { |s| s != 'x' && s != '■' }
        )
        expect(board.tie?).to be true
        expect(board.game_is_over?).to be true
      end
    end

    context 'when the game is not over' do
      it 'returns false' do
        board.mark_spot(0, 'x')
        expect(board.game_is_over?).to be false
      end
    end
  end
end
