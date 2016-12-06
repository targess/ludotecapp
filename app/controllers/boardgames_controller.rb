class BoardgamesController < ApplicationController
  def index
    @boardgames = Boardgame.all
  end

  def show
    @boardgame = Boardgame.find_by(id: params[:id])
  end

  def new
    @boardgame = Boardgame.new
  end

  def edit
    @boardgame = Boardgame.find_by(id: params[:id])
  end

  def create
    @boardgame = Boardgame.new(boardgame_params)
    if @boardgame.save
      redirect_to @boardgame, notice: 'Boardgame was successfully created.'
    else
      render :new
    end
  end

  def update
    @boardgame = Boardgame.find_by(id: params[:id])
    if @boardgame.update(boardgame_params)
      redirect_to @boardgame
    else
      render :edit
    end
  end

  def destroy
    @boardgame = Boardgame.find_by(id: params[:id])
    @boardgame.destroy
    redirect_to boardgames_path
  end


  private

    def boardgame_params
      params.require(:boardgame).permit(:name, :thumbnail, :image, :description, :minplayers, :maxplayers, :playingtime, :minage, :bgg_id)
    end

end
