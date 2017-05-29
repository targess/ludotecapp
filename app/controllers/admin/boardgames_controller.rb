class Admin::BoardgamesController < ApplicationController
  def index
    @boardgames = current_boardgames.order(name: :asc).page(params[:page])
  end

  def show
    @boardgame = current_boardgames.find_by(id: params[:id])
  end

  def new
    @boardgame = Boardgame.new
  end

  def edit
    @boardgame = current_boardgames.find_by(id: params[:id])
  end

  def create
    @boardgame = Boardgame.new(boardgame_params)
    @boardgame.organization = current_organization
    if @boardgame.save
      redirect_to admin_boardgame_url(@boardgame), notice: "Boardgame was successfully created."
    else
      render :new
    end
  end

  def import_from_bgg
    @boardgame  = Boardgame.new
    @boardgames = params[:search].present? ? Boardgame.bgg_search_by_name(params[:search][:keywords]) : []
  end

  def create_from_bgg
    boardgame = Boardgame.new_from_bgg_id(params[:id], params[:name])
    boardgame.organization = current_organization
    if boardgame.save
      redirect_to admin_boardgame_url(boardgame), notice: "Boardgame was successfully created."
    else
      redirect_to :import_from_bgg, alert: "Boardgame fails to import form BGG"
    end
  end

  def update
    @boardgame = current_boardgames.find_by(id: params[:id])
    if @boardgame.update(boardgame_params)
      redirect_to admin_boardgame_url(@boardgame), notice: "Boardgame was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @boardgame = current_boardgames.find_by(id: params[:id])
    if @boardgame.destroy
      redirect_to admin_boardgames_path, notice: "Boardgame was successfully removed."
    else
      redirect_to admin_boardgames_path, alert: @boardgame.errors[:destroy].to_sentence
    end
  end

  private

  def boardgame_params
    params.require(:boardgame).permit(:name, :thumbnail, :image, :description, :minplayers, :maxplayers, :playingtime, :minage, :bgg_id, :barcode, :internalcode, :organization_id)
  end

  def current_organization
    current_user.organization
  end

  def current_boardgames
    current_organization.boardgames
  end
end
