class Admin::Import::BggBoardgamesController < ApplicationController
  def index
    @boardgames = params[:search].present? ? Boardgame.bgg_search_by_name(params[:search][:keywords]) : []
  end

  def create
    boardgame = Boardgame.new_from_bgg_id(params[:id], params[:name])
    boardgame.organization = current_organization
    if boardgame.save
      redirect_to admin_boardgame_path(boardgame), notice: "Boardgame was successfully created."
    else
      render :new, alert: "Boardgame fails to import form BGG"
    end
  end
end
