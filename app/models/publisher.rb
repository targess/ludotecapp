class Publisher < ApplicationRecord
  has_and_belongs_to_many :boardgames

  validates :name, presence: true
end
