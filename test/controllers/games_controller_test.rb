require 'test_helper'

class GamesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @controller = GamesController.new
  end

  class General < GamesControllerTest
    test "GamesController should exist" do
      assert GamesController
    end
  end

  class Actions < GamesControllerTest
    def self.base_tests(verb, &request_block)
      test "should accept #{verb} requests" do
        assert self.instance_eval(&request_block)
      end

      test "should return success" do
        self.instance_eval(&request_block)
        assert_response :success
      end
    end

    def self.base_get_tests(&request_block)
      base_tests("GET", &request_block)

      test "should return JSON" do
        self.instance_eval(&request_block)
        assert_equal Mime[:json].to_s, response.content_type
      end
    end

    def self.base_post_tests(&request_block)
      base_tests("POST", &request_block)
    end

    def self.base_delete_tests(&request_block)
      base_tests("DELETE", &request_block)
    end

    def parsed_body
      JSON.parse(response.body)
    end
  end

  class IndexAction < Actions
    base_get_tests do
      get games_url
    end

    test "should return a list" do
      get games_url

      assert_kind_of Array, parsed_body
    end

    test "should return a list with entries for each Game" do
      games = create_list(:game, rand(1..100))

      get games_url

      assert_equal games.length, parsed_body.length
    end

    test "should return a list with Game summary data" do
      create_list(:game, 10)

      get games_url

      parsed_body.each do |game|
        assert_kind_of Hash, game

        fields = game.keys.map(&:to_sym).to_set
        assert_equal Game::SUMMARY_FIELDS.to_set, fields, "Invalid summary fields for game ##{game["id"] || 'null'}"
      end
    end
  end

  class ShowAction < Actions
    def setup
      @game = create(:game)
    end

    base_get_tests do
      get game_url(id: @game.id)
    end

    test "should return a hash" do
      get game_url(id: @game.id)

      assert_kind_of Hash, parsed_body
    end

    test "should return a hash with Game details data" do
      get game_url(id: @game.id)

      game = parsed_body
      fields = game.keys.map(&:to_sym).to_set
      assert_equal Game::DETAILS_FIELDS.to_set, fields, "Invalid details fields for game ##{game["id"] || 'null'}"
    end

    test "should return the requested Game" do
      get game_url(id: @game.id)

      # Check that the IDs match
      assert_equal @game.id, parsed_body["id"]

      # Check that all of the other fields match
      Game::DETAILS_FIELDS.reject{|f|f == :id}.map(&:to_s).each do |field|
        assert_equal @game.data[field], parsed_body[field], "Mismatch in returned data for game ##{@game.id}, field: #{field}"
      end
    end

    test "should return Not Found for non-existent Game" do
      get game_url(id: @game.id + 1)

      assert_response :missing
    end
  end

  class CreateAction < Actions
    def setup
      @success_body = {
        board: [
          "X", " ", "O",
          "X", "O", " ",
          "X", " ", " "
        ],
        players: [
          "Player 1",
          "Player 2"
        ],
        outcome: "X",
        played_at: DateTime.now.rfc3339
      }
    end

    base_post_tests do
      post games_url, params: @success_body
    end

    test "should save valid Game data to the database" do
      assert_difference "Game.count" do
        post games_url, params: @success_body
      end
    end

    test "should return Bad Request for invalid Game data" do
      post games_url, params: {}

      assert_response :bad_request
    end

    test "should not save invalid Game data to the database" do
      assert_no_difference "Game.count" do
        post games_url, params: {}
      end
    end

    test "should return detailed errors for invalid Game data" do
      post games_url, params: {}

      assert_equal ["errors"], parsed_body.keys, "Error response was not hash with single 'errors' key"

      errors = parsed_body["errors"]
      assert_kind_of Array, errors
      refute_empty errors, "Error details did not include any error messages"

      errors.each do |error|
        assert_kind_of String, error
      end
    end
  end

  class DestroyAction < Actions
    def setup
      @game = create(:game)
    end

    base_delete_tests do
      delete game_url(id: @game.id )
    end

    test "should remove Game from the database" do
      assert_difference "Game.count", -1 do
        delete game_url(id: @game.id )
      end

      assert_nil Game.find_by(id: @game.id)
    end

    test "should return Not Found for non-existent Game" do
      delete game_url(id: @game.id + 1 )

      assert_response :missing
    end
  end
end
