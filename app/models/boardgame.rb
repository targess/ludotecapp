class Boardgame < ApplicationRecord
  include SoftDeletable

  has_and_belongs_to_many :events, -> { distinct }, before_add: :cant_add_boardgame_with_active_loans
  has_and_belongs_to_many :publishers
  has_many :loans
  has_many :tournaments
  belongs_to :organization

  validates :name, presence: true
  validates :maxplayers, presence: true
  validates :organization, presence: true
  validates :barcode, length: { is: 13 }, allow_blank: true
  validates :internalcode, length: { is: 5 }, allow_blank: true

  scope :search_by_name, ->(keyword) { where('lower(name) LIKE ?', "%#{keyword}%".downcase) }
  scope :search_by_barcode, ->(keyword) { where(barcode: keyword) }
  scope :search_by_internalcode, ->(keyword) { where('lower(internalcode) = ?', keyword.downcase) }

  def active_loans
    loans.where(returned_at: nil)
  end

  private

  def cant_add_boardgame_with_active_loans(_event)
    return if active_loans.blank?
    errors.add(:event, "boardgame with active loans can't be added")
    raise ActiveRecord::Rollback
  end
end
