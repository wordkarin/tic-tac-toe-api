require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test "can create a Game" do
    game = create(:game)

    assert_not_nil game
    assert_kind_of Hash, game.data
    refute_empty game.data
    assert game.persisted?
  end

  class Validations < GameTest
    test "can create a valid Game" do
      game = create(:game)

      assert_not_nil game
      assert game.valid?
      assert game.persisted?
    end

    def assert_invalid(game)
      assert_not_nil game
      refute game.valid?
    end

    # Test required attributes
    [:board, :players, :outcome].each do |attr|
      test "Game data must have a #{attr} attribute" do
        game = Game.new(data: attributes_for(:game).except(attr))

        assert_invalid game
      end
    end
  end
end
