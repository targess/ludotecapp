class BoardgamesController < ApplicationController
  before_action :find_event

  def index
    @boardgames = @event.boardgames.all
  end

  def show
    @boardgame = @event.boardgames.find_by(id: params[:id])


    respond_to do |format|
      format.html
      format.json { render json: { attributes: @boardgame, free: @boardgame.free_to_loan? }}
      # format.json { render json: @boardgame }
    end
  end

  def new
    @boardgame = @event.boardgames.new
  end

  def edit
    @boardgame = @event.boardgames.find_by(id: params[:id])
  end

  def create
    @boardgame = @event.boardgames.new(boardgame_params)
    if @boardgame.save
      redirect_to @boardgame, notice: 'Boardgame was successfully created.'
    else
      render :new
    end
  end

  def update
    @boardgame = @event.boardgames.find_by(id: params[:id])
    if @boardgame.update(boardgame_params)
      redirect_to @boardgame
    else
      render :edit
    end
  end

  def destroy
    @boardgame = @event.boardgames.find_by(id: params[:id])
    @boardgame.destroy
    redirect_to boardgames_path
  end


  private

    def boardgame_params
      params.require(:boardgame).permit(:name, :thumbnail, :image, :description, :minplayers, :maxplayers, :playingtime, :minage, :bgg_id)
    end

    def find_event
      @event = Event.find(params[:event_id])
    end
end
