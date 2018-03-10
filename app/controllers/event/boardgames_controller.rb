class Event::BoardgamesController < ApplicationController
  include Events::CheckAuthorized

  before_action :find_event, :set_organization_boardgames

  def index
    @boardgames_included     = @event.boardgames.order(name: :asc).to_a
    @boardgames_not_included = @boardgames.where.not(id: @boardgames_included).order(name: :asc)
  end

  def show
    @boardgame = @boardgames.find_by(id: params[:id])
    @loan      = @boardgame.active_loans

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

  def update
    @boardgame = @boardgames.find_by(id: params[:id])
    @boardgame.events << @event

    if @boardgame.save
      redirect_to event_boardgames_path, notice: "Juego añadido al evento."
    else
      redirect_to event_boardgames_path, alert: @boardgame.errors
    end
  end

  def destroy
    @boardgame = @boardgames.find_by(id: params[:id])
    @boardgame.events.delete(@event)
    redirect_to event_boardgames_path, notice: "Juego eliminado del evento."
  end

  private

  def find_event
    @event = Event.find(params[:event_id])
  end

  def set_organization_boardgames
    @boardgames = @event.organization.boardgames
  end
end
