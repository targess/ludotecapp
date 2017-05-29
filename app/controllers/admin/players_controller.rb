class Admin::PlayersController < ApplicationController
  def index
    @players = current_players.page(params[:page])
  end

  def show
    @player = current_players.find_by(id: params[:id])
  end

  def new
    @player = Player.new
  end

  def edit
    @player = current_players.find_by(id: params[:id])
  end

  def create
    @player = Player.new(player_params)
    @player.organization = current_organization
    if @player.save
      redirect_to admin_player_url(@player), notice: "Player was successfully created."
    else
      render :new
    end
  end

  def update
    @player = current_players.find_by(id: params[:id])
    if @player.update(player_params)
      redirect_to admin_player_url(@player), notice: "Player was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @player = current_players.find_by(id: params[:id])
    if @player.destroy
      redirect_to admin_players_path, notice: "Player was successfully removed."
    else
      redirect_to admin_players_path, alert: @player.errors[:destroy].to_sentence
    end
  end

  private

  def player_params
    params.require(:player).permit(:dni, :firstname, :lastname, :city, :province, :birthday, :email, :phone)
  end

  def current_organization
    current_user.organization
  end

  def current_players
    current_organization.players
  end
end
