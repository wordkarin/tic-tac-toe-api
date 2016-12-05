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

    test "Game board must be an array of nine valid cells" do
      game = build(:game, board: [" "] * 8)
      assert_invalid game

      game = build(:game, board: [" "] * 10)
      assert_invalid game
    end

    test "Game board must be only valid cells" do
      ["X", "O", " "].each do |value|
        board = [value] * 9
        game = build(:game, board: board)
        assert_valid game

        board[0] = ""
        game = build(:game, board: board)
        assert_invalid game
      end
    end

    test "Game players must be non-empty strings" do
      players = attributes_for(:game)[:players]

      players.length.times do |i|
        invalid_players = players.dup
        invalid_players[i] = ""
        game = build(:game, players: invalid_players)

        assert_invalid game
      end
    end

    test "Game must have one or two players" do
      game = build(:game, players: [])
      assert_invalid game

      game = build(:game, players: ["Player 1", "Player 2", "Player 3"])
      assert_invalid game
    end

    test "Game outcome must be X, O, or draw" do
      ["X", "O", "draw"].each do |value|
        game = build(:game, outcome: value)
        assert_valid game
      end

      ["", "invalid", "x", "o", "DRAW"].each do |value|
        game = build(:game, outcome: value)
        assert_invalid game
      end
    end

    test "Game played_at must be a valid datetime" do
      game = build(:game, played_at: DateTime.new(1815, 12, 10))
      assert_valid game

      ["not a date", ""].each do |value|
        game = build(:game, played_at: value)
        assert_invalid game
      end
    end
  end

  class Attributes < GameTest
    test "Game's default played_at date == created_at date" do
      game = Game.new(data: attributes_for(:game).except(:played_at))
      game.save

      assert_includes game.data.keys, "played_at"
      assert_equal game.created_at, game.data["played_at"]
    end

    test "Game accepts a specific date for played_at" do
      played_at = DateTime.new(1815, 12, 10)
      game = create(:game, played_at: played_at)

      assert_includes game.data.keys, "played_at"
      assert_equal played_at, game.data["played_at"]
      assert_not_equal game.created_at, game.data["played_at"]
    end
  end
end
