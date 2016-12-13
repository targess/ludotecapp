class Participant < ApplicationRecord
  belongs_to :player
  belongs_to :tournament

  validates_presence_of :player, :tournament
  validates_uniqueness_of :player, :scope => :tournament
  validate :max_participants_rearched, :must_have_at_least_tournament_minage, on: :create

  before_save :supplent_when_competitors_reached

  private

  def max_participants_rearched
    return nil unless tournament.present?
    if tournament.participants.count >= tournament.max_participants
      errors.add(:tournament, "max participants are rearched")
    end
  end

  def must_have_at_least_tournament_minage
    return nil unless tournament.present? & player.present?
    errors.add(:tournament, "player under minimal age") if player.age < tournament.minage
  end

  def supplent_when_competitors_reached
    return nil unless tournament.present?
     if (tournament.participants.count) >= tournament.max_competitors
      self.substitute = true
     end
  end

end
