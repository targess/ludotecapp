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

  def get_confirmed
    participants.where(confirmed: true)
  end

  def league_system(my_teams = get_confirmed)
    teams             = my_teams.to_a
    rounds            = {}
    rounds[:home]     = []
    rounds[:away]     = []
    number_of_rounds  = teams.length - 1
    number_of_matches = teams.length / 2

    number_of_rounds.times do
      matches_home = []
      matches_away = []

      number_of_matches.times do |index|
        team_1 = teams[index]
        team_2 = teams[number_of_rounds - index]

        matches_home << [team_1, team_2]
        matches_away << [team_2, team_1]
      end

      rounds[:home] << matches_home
      rounds[:away] << matches_away

      # rotate teams
      last = teams.pop
      teams.insert(1, last)
    end

    return rounds
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
