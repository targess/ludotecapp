class Loan < ApplicationRecord
  belongs_to :boardgame
  belongs_to :event
  belongs_to :player

  validates :boardgame, :event, :player, presence: true
  validate :returned_at_cannot_be_before_created_at, :player_not_returned_limit_rearched
  validate :boardgame_not_available_at_event, on: :create

  def self.ordered_loans
    where(returned_at: nil).order(created_at: :desc) + where.not(returned_at: nil).order(returned_at: :desc)
  end

  def return(time = Time.now)
    update(returned_at: time)
  end

  private

  def returned_at_cannot_be_before_created_at
    return false unless returned_at.present?
    errors.add(:returned_at, "can't be before created_at") if created_at > returned_at
  end

  def boardgame_not_available_at_event
    return false unless boardgame.present? && event.present? && boardgame.active_loans(event).present?
    errors.add(:boardgame, "can't be loaned if boardgame not available")
  end

  def player_not_returned_limit_rearched
    return false unless event.present?
    player_not_returned_loans = event.loans.where(returned_at: nil, player: player).count
    return false if event.loans_limits.zero?
    errors.add(:player, "max loans rearched") if player_not_returned_loans >= event.loans_limits
  end
end
