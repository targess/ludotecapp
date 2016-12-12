class Tournament < ApplicationRecord
  belongs_to :boardgame
  belongs_to :event
end
