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

  def active_loans
    loans.where(returned_at: nil)
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
end
