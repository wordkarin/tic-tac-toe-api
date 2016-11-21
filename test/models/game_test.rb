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
      game = create(:game_complete)

      assert_not_nil game
      assert game.valid?
      assert game.persisted?
    end

    def assert_invalid(game)
      assert_not_nil game
      refute game.valid?
      refute game.save
    end

    test "Game must have a board" do
      game = build(:game_without_board)

      assert_invalid game
    end

    test "Game must have a players list" do
      game = build(:game_without_players)

      assert_invalid game
    end

    test "Game must have an outcome" do
      game = build(:game_without_outcome)

      assert_invalid game
    end
  end
end
