class Event::ParticipantsController < ApplicationController
  include Events::CheckAuthorized

  before_action :find_event, :find_tournament

  def create
    player = @event.players.find_by(id: params[:search][:player_id])

    if player
      @participant = @tournament.participants.new(player: player)
      if @participant.save
        flash[:notice] = 'Jugador añadido al torneo.'
      else
        flash[:alert] = 'El jugador no pudo ser añadido. Puede que ya esté en el torneo, o no existan más plazas libres'
      end
    else
      flash[:alert] = 'DNI no válido, no se pudo añadir al jugador al torneo.'
    end

    redirect_to event_tournament_path(@event, @tournament)
  end

  def destroy
    @participant = @tournament.participants.find_by(id: params[:id])

    if @participant.destroy
      flash[:notice] = 'Jugador eliminado del torneo.'
    else
      flash[:alert] = @participant.errors[:destroy].to_sentence
    end

    redirect_to event_tournament_path(@event, @tournament)
  end

  def update
    @participant = @tournament.participants.find_by(id: params[:id])
    @participant.toggle_confirmed
    @participant.save

    redirect_to event_tournament_path(@event, @tournament), notice: 'Jugador confirmado.'
  end

  private

  def find_event
    @event = Event.find(params[:event_id])
  end

  def find_tournament
    @tournament = @event.tournaments.find_by(id: params[:tournament_id])
  end
end
