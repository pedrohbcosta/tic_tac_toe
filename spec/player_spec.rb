require_relative '../game'

RSpec.describe Player do
  let(:board) { Board.new }
  let(:player) { Player.new('x') }

  describe 'when the game starts' do
    it 'assigns a marker to the player' do
      expect(player.marker).to eq('x')
    end
  end

  describe 'when the spot is available' do
    context 'enters a valid spot' do
      before do
        allow(player).to receive(:gets).and_return('0')
      end

      it 'marks the spot on the board' do
        player.get_spot(board)
        expect(board.available_spaces).not_to include('0')
      end
    end

    context 'when the player enters an invalid spot' do
      it 'prompts the player to enter a valid spot' do
        allow(player).to receive(:gets).and_return('-1', '2')

        expected_message = 'Invalid input. Please enter a number between 0 and 8 that has not already been taken.'
        expect { player.get_spot(board) }.to output(include(expected_message)).to_stdout
      end
    end

    context 'when the player enters a spot that has already been taken' do
      before do
        board.mark_spot(0, 'o')
        allow(player).to receive(:gets).and_return('0', '1')
      end

      it 'prompts the player to enter a valid spot' do
        expected_message = 'Invalid input. Please enter a number between 0 and 8 that has not already been taken.'
        expect { player.get_spot(board) }.to output(include(expected_message)).to_stdout
      end
    end
  end
end
