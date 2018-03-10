class Player < ApplicationRecord
  include SoftDeletable

  has_and_belongs_to_many :events
  has_and_belongs_to_many :organizations, -> { distinct }
  has_many :loans
  has_many :participants

  validates_presence_of :firstname, :lastname
  validates_size_of :phone, is: 9
  validates :dni, spanish_vat: true, presence: true,
                  uniqueness: { case_sensitive: false }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  after_destroy :remove_future_participants

  def name
    "#{firstname} #{lastname}"
  end

  def dni_plus_name
    "#{dni} | #{name}"
  end

  def age
    return '' unless birthday
    today = Date.today
    had_birthday = today.month > birthday.month || (today.month == birthday.month && today.day >= birthday.day) ? true : false
    today.year - birthday.year - (had_birthday ? 0 : 1)
  end

  def active_loans
    loans.where(returned_at: nil)
  end

  private

  def remove_future_participants
    return false unless participants.present?
    participants.each do |participant|
      participant.destroy if participant.at_future_tournament?
    end
  end
end
