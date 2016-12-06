class PlayersController < ApplicationController
  def index
    @players = Player.all
  end

  def show
    @player = Player.find_by(id: params[:id])
  end

  def new
    @player = Player.new
  end

  def edit
    @player = Player.find_by(id: params[:id])
  end

  def create
    @player = Player.new(player_params)
    if @player.save
      redirect_to @player, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def update
    @player = Player.find_by(id: params[:id])
    if @player.update(player_params)
      redirect_to @player
    else
      render :edit
    end
  end

  def destroy
    @player = Player.find_by(id: params[:id])
    @player.destroy
    redirect_to players_path
  end


  private

    def player_params
      params.require(:player).permit(:dni, :firstname, :lastname, :city, :province, :birthday, :email, :phone)
    end
end
