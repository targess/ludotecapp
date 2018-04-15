class Publisher < ApplicationRecord
  has_and_belongs_to_many :boardgames

  validates :name, presence: true
  validates :bgg_id, uniqueness: true

  def self.from_hash(publisher = {})
    return nil unless publisher.present?
    Publisher.find_by(bgg_id: publisher[:bgg_id]) || Publisher.new(publisher)
  end
end
