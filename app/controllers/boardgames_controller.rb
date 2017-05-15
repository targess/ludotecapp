class BoardgamesController < ApplicationController
  before_action :find_event, :set_organization_boardgames

  def index
    @boardgames_included     = @event.boardgames.order(name: :asc).to_a
    @boardgames_not_included = @boardgames.where.not(id: @boardgames_included).order(name: :asc)
  end

  def show
    @boardgame = @boardgames.find_by(id: params[:id])
    @loan      = @boardgame.active_loans(@event)

    if @loan.present?
      loan_json = {
        id:  @loan[0].id,
        dni: @loan[0].player.dni,
        name: @loan[0].player.name
      }
    end

    respond_to do |format|
      format.html
      format.json do
        render json: {
          attributes: @boardgame,
          loan:       loan_json
        }
      end
    end
  end

  def add
    @boardgame = @boardgames.find_by(id: params[:id])
    @event.boardgames.push(@boardgame)
    redirect_to event_boardgames_path, notice: "Juego añadido al evento."
  end

  def del
    @boardgame = @boardgames.find_by(id: params[:id])
    @event.boardgames.delete(@boardgame)
    redirect_to event_boardgames_path, notice: "Juego eliminado del evento."
  end

  private

  def find_event
    @event = Event.find(params[:event_id])
  end

  def set_organization_boardgames
    @boardgames = current_organization.boardgames
  end

  def current_organization
    @event.organization
  end
end
