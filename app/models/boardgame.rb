class Boardgame < ApplicationRecord
  include SoftDeletable

  has_and_belongs_to_many :events
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
end
