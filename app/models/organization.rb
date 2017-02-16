class Organization < ApplicationRecord
  has_and_belongs_to_many :players, -> { distinct }
  has_many :events
  has_many :boardgames
  has_many :users

  validates :name, presence: true
end
