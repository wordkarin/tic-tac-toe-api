class GamesController < ApplicationController
  def index
    render json: Game.all, fields: Game::SUMMARY_FIELDS
  end

  def show
  end
end
