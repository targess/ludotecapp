class Participant < ApplicationRecord
  belongs_to :player
  belongs_to :tournament
end
