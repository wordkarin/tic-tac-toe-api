class GamesController < ApplicationController
  def index
    render json: Game.all, fields: Game::SUMMARY_FIELDS
  end

  def show
    render json: {}
  end
end
