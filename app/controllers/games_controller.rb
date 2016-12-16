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
    game = Game.new(data: create_params.to_h)
    if !game.valid?
      return render json: { errors: game.errors.messages[:base] },
                    status: :bad_request
    end

    begin
      game.save!
      head :created, location: game_url(game)
    rescue
      render json: { errors: ["Could not persist Game to database"] },
             status: :internal_server_error
    end
  end

  def destroy
    game = Game.find_by(id: params[:id])
    if game.nil?
      return head :not_found
    end

    raise unless game.destroy
    head :no_content
  rescue
    render json: { errors: ["Could not remove Game from database"] },
           status: :internal_server_error
  end

  private

  def create_params
    # Don't allow client to specify Game ID
    params.slice(*Game::DETAILS_FIELDS.reject{|f|f==:id}).permit!
  end
end
