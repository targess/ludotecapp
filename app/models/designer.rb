class Designer < ApplicationRecord
  has_and_belongs_to_many :boardgames

  validates :name, presence: true
  validates :bgg_id, uniqueness: true

  def self.from_hash(designer = {})
    return nil unless designer.present?
    Designer.find_by(bgg_id: designer[:bgg_id]) || Designer.new(designer)
  end
end
