class PlayersController < ApplicationController
  before_action :find_event
  def index
    @players = @event.players.all
  end

  def show
    @player = @event.players.find_by(id: params[:id])
  end

  def show_by_dni
    player = Player.find_by(dni: params[:dni])
    unless player
      render json: {error: "player not found"},
      status: 404
      return
    end
    render json: player
  end

  def new
    @player = @event.players.new
  end

  def edit
    @player = @event.players.find_by(id: params[:id])
  end

  def create
    @player = @event.players.new(player_params)
    if @player.save
      redirect_to [@event, @player], notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def update
    @player = @event.players.find_by(id: params[:id])

    unless @player
      @player = Player.find_by(id: params[:id])
      @event.players.push(@player)
    end

    if @player.update(player_params)
      redirect_to [@event, @player], notice: 'User was successfully included.'
    else
      render :edit
    end
  end

  def destroy
    @player = @event.players.find_by(id: params[:id])
    @player.destroy
    redirect_to event_players_path
  end

  private

    def player_params
      params.require(:player).permit(:dni, :firstname, :lastname, :city, :province, :birthday, :email, :phone)
    end

    def find_event
      @event = Event.find(params[:event_id])
    end
end
