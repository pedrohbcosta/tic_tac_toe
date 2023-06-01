require '../game'

RSpec.describe ComputerPlayer do
  let(:board) { Board.new }
  let(:computer_player) { ComputerPlayer.new('x', 'hard') }
  let(:easy_computer_player) { ComputerPlayer.new('x', 'easy') }

  describe 'when the game starts' do
    it 'creates a new computer player with a marker and difficulty level' do
      expect(computer_player.marker).to eq('x')
      expect(computer_player.difficulty).to eq('hard')
    end
  end

  describe 'when the game is about to start' do
    context "when the difficulty is 'hard'" do
      it 'returns a valid spot to place a marker on the board' do
        allow(board).to receive(:available_spaces).and_return(%w[0 1 2 3 4 5 6 7 8])
        expect(board).to receive(:mark_spot).with(4, 'x')
        expect(computer_player.get_spot(board)).to eq(4)
      end
    end

    context "when the difficulty is 'easy'" do
      it 'returns a valid spot to place a marker on the board' do
        allow(board).to receive(:available_spaces).and_return(%w[2 3 4 5 6 7])
        expect(board).to receive(:mark_spot).with(2, 'x')
        expect(easy_computer_player.get_spot(board)).to eq(2)
      end
    end
  end

  describe "when it's time to the computer plays" do
    let(:board) { Board.new }

    it 'returns a valid spot to place a marker on the board' do
      allow(board).to receive(:available_spaces).and_return(%w[0 1 2 3 4 5 6 7 8])
      expect { computer_player.send(:get_best_move, board) }.not_to change { board.available_spaces }
      expect(computer_player.send(:get_best_move, board)).to be_between(0, 8)
    end
  end
end
