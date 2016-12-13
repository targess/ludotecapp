class TournamentsController < ApplicationController
  before_action :find_event
  def index
    @tournaments = @event.tournaments.all
    @tournament  = @event.tournaments.new
  end

  def show
    @tournament  = @event.tournaments.find_by(id: params[:id])
    @boardgame   = @tournament.boardgame
    @competitors = @tournament.participants.where(substitute: false)
    @substitutes = @tournament.participants.where(substitute: true)
  end

  private

    def tournament_params
      params.require(:tournament).permit(:name, :max_competitors, :max_substitutes, :date, :minage)
    end

    def find_event
      @event = Event.find(params[:event_id])
    end
end
