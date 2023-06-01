require_relative '../game'

RSpec.describe Game do
  describe 'when a game object is created' do
    let(:game) { Game.new }

    it 'creates a new board' do
      allow_any_instance_of(Game).to receive(:gets).and_return('1')

      expect(game.instance_variable_get(:@board)).to be_an_instance_of(Board)
    end

    context 'sets game mode' do
      it 'prompts the player to enter a valid mode' do
        allow_any_instance_of(Game).to receive(:gets).and_return('1')

        expected_message = 'Please, select the game mode: 1 for PvP, 2 for PvC or 3 for CvC'
        expect { game }.to output(include(expected_message)).to_stdout
      end

      it 'prompts the player to enter a invalid mode' do
        allow_any_instance_of(Game).to receive(:gets).and_return('3', '1')

        expected_message = 'Please, select the game mode: 1 for PvP, 2 for PvC or 3 for CvC'
        expect { game }.to output(include(expected_message)).to_stdout
      end

      it 'when pvp' do
        allow_any_instance_of(Game).to receive(:gets).and_return('1')

        expect(game.instance_variable_get(:@mode)).to eq('pvp')
        expect(game.instance_variable_get(:@player1)).to be_an_instance_of(Player)
        expect(game.instance_variable_get(:@player2)).to be_an_instance_of(Player)
        expect(game.instance_variable_get(:@current_player)).to be_an_instance_of(Player)
      end

      it 'when pvc' do
        allow_any_instance_of(Game).to receive(:gets).and_return('2', '1')

        expect(game.instance_variable_get(:@mode)).to eq('pvc')
        expect(game.instance_variable_get(:@player1)).to be_an_instance_of(Player)
        expect(game.instance_variable_get(:@player2)).to be_an_instance_of(ComputerPlayer)
      end

      it 'when cvc' do
        allow_any_instance_of(Game).to receive(:gets).and_return('3', '1')

        expect(game.instance_variable_get(:@mode)).to eq('cvc')
        expect(game.instance_variable_get(:@player1)).to be_an_instance_of(ComputerPlayer)
        expect(game.instance_variable_get(:@player2)).to be_an_instance_of(ComputerPlayer)
      end
    end

    context 'computer difficulty' do
      it 'prompts the player to enter a valid difficulty' do
        allow_any_instance_of(Game).to receive(:gets).and_return('3', '1')

        expected_message = 'Please, select 1 for easy and 2 for hard'
        expect { game }.to output(include(expected_message)).to_stdout
      end

      it 'prompts the player to enter a invalid difficulty' do
        allow_any_instance_of(Game).to receive(:gets).and_return('3', '3', '2')

        expected_message = 'Invalid difficulty selected. Please select a valid difficulty.'
        expect { game }.to output(include(expected_message)).to_stdout
      end

      it 'when the mode is easy' do
        allow_any_instance_of(Game).to receive(:gets).and_return('3', '1')

        expect(game.instance_variable_get(:@difficulty)).to eq('easy')
      end

      it 'when the mode is hard' do
        allow_any_instance_of(Game).to receive(:gets).and_return('3', '2')

        expect(game.instance_variable_get(:@difficulty)).to eq('hard')
      end
    end

    context 'when the game ends' do
      it 'returns tie' do
        allow_any_instance_of(Game).to receive(:gets).and_return('1')
        allow_any_instance_of(Player).to receive(:gets).and_return('0', '3', '1', '2', '4', '7', '5', '8', '6')

        game.start

        expected_message = "It's a tie!"
        expect { game.send(:print_game_result) }.to output(include(expected_message)).to_stdout
      end

      it 'returns player 1 wins' do
        allow_any_instance_of(Game).to receive(:gets).and_return('1')
        allow_any_instance_of(Player).to receive(:gets).and_return('0', '3', '1', '4', '2')

        game.start

        expected_message = 'Player 1 wins!'
        expect { game.send(:print_game_result) }.to output(include(expected_message)).to_stdout
      end

      it 'returns player 2 wins' do
        allow_any_instance_of(Game).to receive(:gets).and_return('1')
        allow_any_instance_of(Player).to receive(:gets).and_return('3', '0', '4', '1', '7', '2')

        game.start

        expected_message = 'Player 2 wins!'
        expect { game.send(:print_game_result) }.to output(include(expected_message)).to_stdout
      end
    end
  end
end
