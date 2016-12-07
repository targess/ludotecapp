class LoansController < ApplicationController
  before_action :find_event

  def index
    @loans = @event.loans.all
  end

  def show
    @loan = @event.loans.find_by(id: params[:id])
  end

  def new
    @loan = @event.loans.new
  end

  def edit
    @loan = @event.loans.find_by(id: params[:id])
  end

  def create
    @loan = @event.loans.new(loan_params)
    if @loan.save
      redirect_to @loan, notice: 'Loan was successfully created.'
    else
      render :new
    end
  end

  def update
    @loan = @event.loans.find_by(id: params[:id])
    if @loan.update(loan_params)
      redirect_to @loan
    else
      render :edit
    end
  end

  def destroy
    @loan = @event.loans.find_by(id: params[:id])
    @loan.destroy
    redirect_to event_loans_path
  end

  private

    def loan_params
      params.require(:loan).permit(:returned_at, :boardgame_id, :player_id)
    end

    def find_event
      @event = Event.find(params[:event_id])
    end
end
