class Event < ApplicationRecord

  has_and_belongs_to_many :boardgames, -> { distinct }
  has_and_belongs_to_many :players, -> { distinct }
  has_many :loans
  has_many :tournaments

  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate  :start_date_cannot_be_after_end_date

  def start_date_cannot_be_after_end_date
    if start_date != nil && end_date != nil
      if start_date > end_date
        errors.add(:start_date, "can't be after end_date")
      end
    end
  end
end
