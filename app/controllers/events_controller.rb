class EventsController < ApplicationController
  before_action :set_organization
  before_action :current_user_is_the_owner, only: [:show, :edit, :update, :destroy]

  def index
    @events = current_user.admin? ? Event.all : @organization.events
  end

  def show
    @event             = Event.find_by(id: params[:id])
    @loans_count       = @event.loans.count
    @boardgames_count  = @event.boardgames.count
    @players_count     = @event.players.count
    @tournaments_count = @event.tournaments.count
  end

  def new
    @event = Event.new
  end

  def edit
    @event = Event.find_by(id: params[:id])
  end

  def create
    @event = Event.new(event_params)
    @event.organization = @organization
    if @event.save
      redirect_to @event, notice: "Event was successfully created."
    else
      render :new
    end
  end

  def update
    @event = Event.find_by(id: params[:id])
    if @event.update(event_params)
      redirect_to @event
    else
      render :edit
    end
  end

  def destroy
    @event = Event.find_by(id: params[:id])
    @event.destroy
    redirect_to events_path
  end

  private

  def event_params
    params.require(:event).permit(:name, :start_date, :end_date, :city, :province)
  end

  def set_organization
    @organization = current_user.organization
  end

  def current_user_is_the_owner
    @event = Event.find_by(id: params[:id])
    unless @event.organization == current_user.organization || current_user.admin?
      redirect_to root_path, notice: "Acess forbidden"
    end
  end
end
