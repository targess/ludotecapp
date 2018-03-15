class Event::LoansController < ApplicationController
  include Events::CheckAuthorized

  before_action :find_event

  def index
    @loan  = Loan.new
    @loans = @event.loans.ordered
    keywords = params.fetch(:search, {}).fetch(:keywords, nil)
    @boardgames = search_boardgame_to_borrow_by_keyword(keywords)
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

  def destroy
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

  def search_boardgame_to_borrow_by_keyword(keyword)
    return [] unless keyword.present?

    if keyword.length == 13 && keyword.match(/^\d+$/)
      @event.boardgames.search_by_barcode(keyword)
    elsif keyword.length == 5 && keyword.match(/^[a-zA-Z]{2}\d{3}/)
      @event.boardgames.search_by_internalcode(keyword)
    else
      @event.boardgames.search_by_name(keyword)
    end
  end
end
