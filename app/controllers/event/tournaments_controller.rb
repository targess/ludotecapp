class Event::TournamentsController < ApplicationController
  include Events::CheckAuthorized

  autocomplete :boardgame, :name, full: true, limit: 20, extra_data: [:thumbnail]
  autocomplete :player, :dni, limit: 20, extra_data: [:firstname, :lastname], display_value: :dni_plus_name
  before_action :find_event

  def index
    @tournaments = @event.tournaments.all
    @tournament  = @event.tournaments.new
  end

  def show
    @tournament    = @event.tournaments.find_by(id: params[:id])
    @boardgame     = @tournament.boardgame
    @competitors   = @tournament.competitors
    @substitutes   = @tournament.substitutes
    @confirmed     = @tournament.confirmed
    @league_rounds = @tournament.league_system(@confirmed) if @confirmed.present?
  end

  def create
    @tournaments = @event.tournaments.all
    @tournament  = @event.tournaments.new(tournament_params)

    if @event.save
      redirect_to [@event, @tournament], notice: 'Tournament was successfully created.'
    else
      render :index, alert: 'Sorry, tournament wasnt created.'
    end
  end

  def edit
    @tournament = @event.tournaments.find_by(id: params[:id])
  end

  def update
    @tournament = @event.tournaments.find_by(id: params[:id])

    if @tournament.update(tournament_params)
      redirect_to [@event, @tournament], notice: 'Tournament was successfully updated.'
    else
      render :edit
    end
  end

  private

  def get_autocomplete_items(parameters)
    items = active_record_get_autocomplete_items(parameters)

    if    parameters[:model] == Boardgame then @event.boardgames & items
    elsif parameters[:model] == Player    then @event.players & items
    end
  end

  def tournament_params
    params.require(:tournament).permit(:name, :max_competitors, :max_substitutes, :date, :minage, :boardgame_id, :event)
  end

  def find_event
    @event = Event.find(params[:event_id])
  end
end
