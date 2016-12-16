class GamesController < ApplicationController
  def index
    render json: Game.all, fields: Game::SUMMARY_FIELDS
  end

  def show
    game = Game.find_by(id: params[:id])
    if game.nil?
      return head :not_found
    end

    render json: game, fields: Game::DETAILS_FIELDS
  end

  def create
  end
end
