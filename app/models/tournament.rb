class Tournament < ApplicationRecord
  belongs_to :boardgame
  belongs_to :event
  has_many :participants

  validates_presence_of :name, :date, :max_competitors, :max_substitutes, :event, :boardgame
  validate :date_must_be_at_event_range

  def max_participants
    max_competitors + max_substitutes
  end

  def get_competitors
    participants.where(substitute: false)
  end

  def get_substitutes
    participants.where(substitute: true)
  end

  private

  def date_must_be_at_event_range
    return nil unless date.present? && event.present?
    if date < event.start_date
      errors.add(:date, "can't be before event start date")
    elsif date > event.end_date
      errors.add(:date, "can't be afer event end date")
    end
  end

end