class AddOrganizationToBoardgames < ActiveRecord::Migration[5.0]
  def change
    add_reference :boardgames, :organization, foreign_key: true
  end
end
