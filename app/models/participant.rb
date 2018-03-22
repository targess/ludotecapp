class Participant < ApplicationRecord
  belongs_to :player, -> { with_deleted }
  belongs_to :tournament

  validates_presence_of :player, :tournament
  validates_uniqueness_of :player, scope: :tournament
  validate :tournament_must_have_free_participants_slots, :must_have_at_least_tournament_minage, on: :create
  validate :tournament_must_have_not_deleted_boardgame

  before_create :supplent_when_competitors_reached
  after_destroy :supplent_to_competitor_when_competitor_destroyed
  before_destroy :not_removed_from_past_tournament

  scope :competitors, -> { where(substitute: false) }
  scope :substitutes, -> { where(substitute: true) }
  scope :confirmed, -> { where(confirmed: true) }

  def toggle_confirmed
    confirmed ? (self.confirmed = false) : (self.confirmed = true)
  end

  def at_future_tournament?
    tournament.date > Time.now
  end

  private

  def tournament_must_have_free_participants_slots
    return false unless tournament.present?
    errors.add(:tournament, "max participants are rearched") if tournament.max_participants_rearched
  end

  def must_have_at_least_tournament_minage
    return false unless tournament.present? & player.present?
    errors.add(:tournament, "player under minimal age") if player.age.blank? || player.age < tournament.minage
  end

  def supplent_when_competitors_reached
    return false unless tournament.present?
    self.substitute = true if tournament.competitors.count >= tournament.max_competitors
  end

  def supplent_to_competitor_when_competitor_destroyed
    return false if substitute
    first_substitute = tournament.substitutes.first
    first_substitute.update(substitute: false) if first_substitute.present?
  end

  def tournament_must_have_not_deleted_boardgame
    return false unless tournament.present?
    boardgame = tournament.boardgame
    errors.add(:tournament, "tournament with invalid boardgame") unless boardgame.deleted_at.nil?
  end

  def not_removed_from_past_tournament
    errors.add(:destroy, "Cannot delete participant from past tournament") unless at_future_tournament?
    throw(:abort) unless at_future_tournament?
  end

  def player_and_tournament_must_be_at_same_event
    return false unless tournament.present? & player.present?
    errors.add(:tournament, "belongs to another event") unless player.events.include?(tournament.event)
  end
end
