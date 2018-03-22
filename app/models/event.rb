class Event < ApplicationRecord
  has_and_belongs_to_many :boardgames, -> { distinct },
                          before_add: :cant_add_boardgame_with_active_loans,
                          before_remove: :cant_del_boardgame_with_active_loans
  has_and_belongs_to_many :players, -> { distinct }
  has_many :loans
  has_many :tournaments
  belongs_to :organization

  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :organization, presence: true
  validate  :start_date_cannot_be_after_end_date

  private

  def start_date_cannot_be_after_end_date
    return unless start_date.present? && end_date.present?
    errors.add(:start_date, "can't be after end_date") if start_date > end_date
  end

  def cant_add_boardgame_with_active_loans(boardgame)
    return if boardgame.active_loans.blank?
    errors.add(:boardgame, "boardgame with active loans can't be added")
    raise ActiveRecord::Rollback
  end

  def cant_del_boardgame_with_active_loans(boardgame)
    return unless boardgame.active_loans.at_event(self)
    errors.add(:boardgame, "boardgame with active loans can't be removed")
    raise ActiveRecord::Rollback
  end
end
