class Player < ApplicationRecord
  acts_as_paranoid
  has_and_belongs_to_many :events
  has_and_belongs_to_many :organizations, -> { distinct }
  has_many :loans
  has_many :participants

  validates_presence_of :firstname, :lastname
  validates_size_of :phone, is: 9
  validates :dni, presence: true, length: { is: 9 },
                  format: { with: /[a-zA-Z]\z/, message: "last char has to be a letter" },
                  uniqueness: { case_sensitive: false }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validate :dni_must_have_valid_format

  before_destroy :mark_fields_as_deleted, :not_removed_with_pending_loans
  after_destroy :really_destroy_when_useless, :remove_future_participants

  def name
    firstname + " " + lastname
  end

  def dni_plus_name
    dni + " | " + name
  end

  def age
    return "" unless birthday
    today = Date.today
    day = Date.new(today.year, birthday.month, birthday.day)
    day.year - birthday.year - (day > today ? 1 : 0)
  end

  def active_loans
    loans.where(returned_at: nil).count
  end

  private

  def dni_must_have_valid_format
    nif_letters = "TRWAGMYFPDXBNJZSQVHLCKE"
    numbers = dni.chop
    errors.add(:dni, "is invalid dni") if dni != numbers + nif_letters[numbers.to_i % nif_letters.length]
  end

  def mark_fields_as_deleted
    update_columns(firstname: "DELETED", lastname: "DELETED", email: "DELETED", dni: "DELETED")
  end

  def not_removed_with_pending_loans
    errors.add(:base, "Cannot delete players with pending loans") unless active_loans.zero?
    throw(:abort) unless active_loans.zero?
  end

  def really_destroy_when_useless
    really_destroy! unless loans.present? || participants.present? || frozen?
  end

  def remove_future_participants
    false unless participants.present?
    participants.each do |participant|
      participant.destroy if participant.at_future_tournament?
    end
  end
end
