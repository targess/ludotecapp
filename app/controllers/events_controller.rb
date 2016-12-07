class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def show
    @event            = Event.find_by(id: params[:id])
    @loans_count      = @event.loans.count
    @boardgames_count = @event.boardgames.count
    @players_count    = @event.players.count
  end

  def new
    @event = Event.new
  end

  def edit
    @event = Event.find_by(id: params[:id])
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to @event, notice: 'Event was successfully created.'
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
end
