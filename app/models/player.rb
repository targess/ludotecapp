class Player < ApplicationRecord
  acts_as_paranoid
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

  before_destroy :not_removed_with_pending_loans, :mark_fields_as_deleted
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
    had_birthday = today.month > birthday.month || (today.month == birthday.month && today.day >= birthday.day) ? true : false
    today.year - birthday.year - (had_birthday ? 0 : 1)
  end

  def active_loans
    loans.where(returned_at: nil).count
  end

  private

  def mark_fields_as_deleted
    update_columns(firstname: "DELETED", lastname: "DELETED", email: "DELETED", dni: "DELETED")
  end

  def not_removed_with_pending_loans
    errors.add(:destroy, "Cannot delete players with pending loans") unless active_loans.zero?
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
