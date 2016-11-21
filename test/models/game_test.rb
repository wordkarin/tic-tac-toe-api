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
    def assert_valid(game)
      assert_not_nil game
      assert game.valid?
    end

    def assert_invalid(game)
      assert_not_nil game
      refute game.valid?
    end

    test "can create a valid Game" do
      game = build(:game)

      assert_valid game

      assert game.save
      assert game.persisted?
    end

    # Test required attributes
    [:board, :players, :outcome].each do |attr|
      test "Game data must have a #{attr} attribute" do
        game = Game.new(data: attributes_for(:game).except(attr))

        assert_invalid game
      end
    end

    test "Game data has an optional played_at attribute" do
      game = Game.new(data: attributes_for(:game).except(:played_at))
      assert_valid game
    end
  end
end
