class Admin::Import::BggCollectionsController < ApplicationController
  def index
    @boardgames = params[:search].present? ? Boardgame.bgg_get_collection(params[:search][:keywords]) : []
  end

  def create
  end
end
