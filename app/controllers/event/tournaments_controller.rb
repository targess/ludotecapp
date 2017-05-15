class TournamentsController < ApplicationController
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
    @participant   = @tournament.participants.new
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
    @tournament  = @event.tournaments.find_by(id: params[:id])
  end

  def update
    @tournament = @event.tournaments.find_by(id: params[:id])

    if @tournament.update(tournament_params)
      redirect_to [@event, @tournament], notice: 'Tournament was successfully updated.'
    else
      render :edit
    end
  end

  def add
    @tournaments = @event.tournaments.all
    @tournament  = @event.tournaments.find_by(id: params[:tournament_id])
    player       = @event.players.find_by(id: params[:search][:player_id])

    if player
      @participant = @tournament.participants.new({player_id: params[:search][:player_id]})

      if @participant.save
        redirect_to event_tournament_path(@event, @tournament), notice: 'Jugador añadido al torneo.'
      else
        redirect_to event_tournament_path(@event, @tournament), alert: 'El jugador no pudo ser añadido. Puede que ya esté en el torneo, o no existan más plazas libres'
      end
    else
      redirect_to event_tournament_path(@event, @tournament), alert: 'DNI no válido, no se pudo añadir al jugador al torneo.'
    end
  end

  def del
    @tournament  = @event.tournaments.find_by(id: params[:tournament_id])
    @participant = @tournament.participants.find_by(id: params[:id])

    @tournament.participants.destroy(@participant)
    redirect_to event_tournament_path(@event, @tournament), notice: 'Jugador eliminado del torneo.'
  end

  def confirm
    @tournament  = @event.tournaments.find_by(id: params[:tournament_id])
    @participant = @tournament.participants.find_by(id: params[:id])
    @participant.toggle_confirmed
    @participant.save
    redirect_to event_tournament_path(@event, @tournament), notice: 'Jugador confirmado.'
  end

  private

    def get_autocomplete_items(parameters)
      items = active_record_get_autocomplete_items(parameters)

      if parameters[:model]    == Boardgame
       @event.boardgames & items
      elsif parameters[:model] == Player
       @event.players & items
      end
    end

    def tournament_params
      params.require(:tournament).permit(:name, :max_competitors, :max_substitutes, :date, :minage, :boardgame_id, :event)
    end

    def find_event
      @event = Event.find(params[:event_id])
    end
end
