class AddDeletedAtToBoardgames < ActiveRecord::Migration[5.0]
  def change
    add_column :boardgames, :deleted_at, :datetime
    add_index :boardgames, :deleted_at
  end
end
