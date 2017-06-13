class Admin::Import::BggBoardgamesController < ApplicationController
  def index
    if params[:search].present?
      @boardgames = BggParser::SearchBoardgameByNameService.perform(params[:search][:keywords])
    end
  end

  def new
    @boardgame = BggParser::NewBoardgameFromIdService.perform(params[:id], params[:name])
  end

  def create
    @boardgame = BggParser::NewBoardgameFromIdService.perform(params[:id], params[:name])
    @boardgame.organization = current_organization
    if @boardgame.save
      redirect_to admin_boardgame_path(@boardgame), notice: "Boardgame was successfully created."
    else
      render :new, alert: "Boardgame fails to import from BGG"
    end
  end

  private

  def current_organization
    current_user.organization
  end
end
