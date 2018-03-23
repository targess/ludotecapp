class Event::PlayersController < ApplicationController
  include Events::CheckAuthorized

  before_action :find_event
  before_action :set_organization, only: [:show_by_dni, :create, :update]

  def index
    @players = @event.players.all
    @player  = @event.players.new
  end

  def show
    @player = @event.players.find_by(id: params[:id])
  end

  def show_by_dni
    player = @organization.players.find_by(dni: params[:dni].upcase)
    unless player
      render json: { error: "player not found" },
             status: 404
      return
    end
    render json: player
  end

  def edit
    @player = @event.players.find_by(id: params[:id])
  end

  def create
    @players = @event.players.all
    @player  = @event.players.new(player_params)
    @player.organizations.push(@organization)
    if @event.save
      redirect_to [@event, @player], notice: "User was successfully created."
    else
      render :index
    end
  end

  def update
    @player = @event.players.find_by(id: params[:id])
    unless @player
      @player = @organization.players.find_by(id: params[:id])
      @event.players.push(@player)
    end

    if @player.update(player_params)
      redirect_to [@event, @player], notice: "User was successfully included."
    else
      render :edit
    end
  end

  private

  def player_params
    params.require(:player).permit(:dni, :firstname, :lastname, :city, :province, :birthday, :email, :phone)
  end

  def find_event
    @event = Event.find(params[:event_id])
  end

  def set_organization
    @organization = @event.organization
  end
end
