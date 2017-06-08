class Admin::Import::BggCollectionsController < ApplicationController
  def index
    if params[:search].present?
      @boardgames = BggParser::GetCollectionService.perform(params[:search][:keywords])
    end
  end

  def create
  end
end
