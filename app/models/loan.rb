class Loan < ApplicationRecord
  belongs_to :boardgame
  belongs_to :event
  belongs_to :player

  validates :boardgame, presence: true
  validates :event, presence: true
  validates :player, presence: true

  validate :returned_at_cannot_be_before_created_at, :player_not_returned_limit_rearched
  validate :boardgame_not_available_at_event, on: :create

  def self.ordered_loans
    where(returned_at: nil).order(created_at: :desc) + where.not(returned_at: nil).order(returned_at: :desc)
  end

  def return (time = Time.now)
    update(returned_at: time)
  end

  private

    def returned_at_cannot_be_before_created_at
      if returned_at != nil
        if created_at > returned_at
          errors.add(:returned_at, "can't be before created_at")
        end
      end
    end

    def boardgame_not_available_at_event
      return nil unless boardgame.present? && event.present?
      if !event.loans.where(returned_at: nil, boardgame: boardgame).count.zero?
        errors.add(:boardgame, "can't be loaned if boardgame not available")
      end
    end

    def player_not_returned_limit_rearched
      return nil unless event.present?
      player_not_returned_loans = event.loans.where(returned_at: nil, player: player).count
      unless event.loans_limits == 0
        if player_not_returned_loans >= event.loans_limits
          errors.add(:player, "max loans rearched")
        end
      end
    end
end
