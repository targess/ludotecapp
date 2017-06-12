class Admin::Import::BggCollectionsController < ApplicationController
  def index
    if params[:search].present?
      @boardgames = BggParser::GetCollectionService.perform(params[:search][:keywords])
    end
  end

  def create
    @boardgames = BggParser::ImportCollectionService.perform(params[:bgg_user], current_organization)
    if @boardgames
      redirect_to admin_boardgames_path, notice: "Collection was successfully imported."
    else
      redirect_to :index, alert: "Collection fails to import from BGG"
    end
  end

  private

  def current_organization
    current_user.organization
  end
end
