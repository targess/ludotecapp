class LoansController < ApplicationController
  before_action :find_event

  def index
    @loan  = Loan.new
    @loans = @event.loans.ordered_loans

    # Pending to move to correct model
    if params[:search].present?
      keyword = params[:search][:keywords]

      if keyword.length == 13 && (Float(keyword) rescue nil)
        @boardgames  = Boardgame.search_by_barcode(keyword, @event)
      elsif keyword.length == 5 && keyword.match(/^[a-zA-Z]{2}\d{3}/)
        @boardgames  = Boardgame.search_by_internalcode(keyword, @event)
      else
        @boardgames  = Boardgame.search_by_name(keyword, @event)
      end
    else
      @boardgames  = []
    end
  end

  def create
    player = @event.players.find_by(dni: params[:dni])

    if player
      @loan = @event.loans.new(boardgame_id: params[:loan][:boardgame_id], player: player)

      if @loan.save
        redirect_to event_loans_url(@event), notice: 'Loan was successfully created.'
      else
        redirect_to event_loans_url(@event), alert: 'Sorry, loans fails to start.'
      end
    else
        redirect_to event_loans_url(@event), alert: 'Invalid DNI, loans fails to start.'
    end
  end

  def return
    @loan = @event.loans.find_by(id: params[:id])

    if @loan.return
      redirect_to event_loans_url(@event), notice: 'Loan was successfully returned.'
    else
      redirect_to event_loans_url(@event), alert: 'Loan fails to return.'
    end
  end

  private

    def find_event
      @event = Event.find(params[:event_id])
    end
end
