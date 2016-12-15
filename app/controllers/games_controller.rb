class GamesController < ApplicationController
  def index
    render json: Game.all, fields: Game::SUMMARY_FIELDS
  end

  def show
    game = Game.find_by(id: params[:id])

    render json: game, fields: Game::DETAILS_FIELDS
  end
end
