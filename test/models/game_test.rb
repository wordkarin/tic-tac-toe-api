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
  end
end
