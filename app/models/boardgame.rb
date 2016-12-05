class Boardgame < ApplicationRecord
  include BggParser

  validates :name, presence: true
  validates :maxplayers, presence: true
end
