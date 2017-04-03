class Admin::BoardgamesController < ApplicationController
  def index
    @boardgames = Boardgame.order(name: :asc).page(params[:page])
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
      redirect_to admin_boardgame_url(@boardgame), notice: 'Boardgame was successfully created.'
    else
      render :new
    end
  end

  def import_from_bgg
    @boardgame = Boardgame.new
    if params[:search].present?
      @boardgames = Boardgame.bgg_search_by_name(params[:search][:keywords])
    else
      @boardgames = []
    end
  end

  def create_from_bgg
    boardgame = Boardgame.new_from_bgg_id(params[:id], params[:name])
    if boardgame.save
      redirect_to admin_boardgame_url(boardgame), notice: 'Boardgame was successfully created.'
    else
      redirect_to :import_from_bgg, alert: 'Boardgame fails to import form BGG'
    end
  end

  def update
    @boardgame = Boardgame.find_by(id: params[:id])
    if @boardgame.update(boardgame_params)
      redirect_to admin_boardgame_url(@boardgame)
    else
      render :edit
    end
  end

  def destroy
    @boardgame = Boardgame.find_by(id: params[:id])
    @boardgame.destroy
    redirect_to admin_boardgames_path
  end

  private

    def boardgame_params
      params.require(:boardgame).permit(:name, :thumbnail, :image, :description, :minplayers, :maxplayers, :playingtime, :minage, :bgg_id, :barcode, :internalcode, :organization_id)
    end
end
