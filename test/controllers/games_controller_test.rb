require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  def setup
    @controller = GamesController.new
  end

  class General < GamesControllerTest
    test "GamesController should exist" do
      assert GamesController
    end
  end

  class Actions < GamesControllerTest
    def self.base_tests_for_get(action)
      test "should accept GET requests" do
        assert get action
      end

      test "should return success" do
        get action
        assert_response :success
      end

      test "should return JSON" do
        get action
        assert_equal Mime[:json].to_s, response.content_type
      end
    end

    def parsed_body
      JSON.parse(response.body)
    end
  end

  class IndexAction < Actions
    base_tests_for_get(:index)
  end
end
