class Boardgame < ApplicationRecord

  has_and_belongs_to_many :events
  has_many :loans
  has_many :tournaments
  belongs_to :organization

  validates :name, presence: true
  validates :maxplayers, presence: true
  validates :organization, presence: true
  validates :barcode, length: { is: 13 }, allow_blank: true
  validates :internalcode, length: { is: 5 }, allow_blank: true

  acts_as_paranoid

  before_destroy :not_removed_with_pending_loans
  before_destroy :remove_internalcode
  after_destroy :really_destroy_when_useless

  def free_to_loan?
    loans.where(returned_at: nil).count.zero?
  end

  def active_loans(event)
    loans.where(returned_at: nil, event: event)
  end

  def at_event?(event)
    events.find_by(id: event)
  end

  def self.search_by_name(keyword, event = nil)
    if event.present?
      event.boardgames.where("lower(name) LIKE ?", "%#{keyword}%".downcase)
    else
      Boardgame.where("lower(name) LIKE ?", "%#{keyword}%".downcase)
    end
  end

  def self.search_by_barcode(keyword, event = nil)
    if event.present?
      event.boardgames.where("barcode = ?", keyword)
    else
      Boardgame.where("barcode = ?", keyword)
    end
  end

  def self.search_by_internalcode(keyword, event = nil)
    if event.present?
      event.boardgames.where("lower(internalcode) = ?", keyword.downcase)
    else
      Boardgame.where("lower(internalcode) = ?", keyword.downcase)
    end
  end

  private

  def remove_internalcode
    update(internalcode: "DEL")
  end

  def really_destroy_when_useless
    really_destroy! unless loans.present? || tournaments.present? || frozen?
  end

  def not_removed_with_pending_loans
    errors.add(:destroy, "Cannot delete boardgames with pending loans") unless free_to_loan?
    throw(:abort) unless free_to_loan?
  end
end
