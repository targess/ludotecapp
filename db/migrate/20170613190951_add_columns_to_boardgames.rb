class AddColumnsToBoardgames < ActiveRecord::Migration[5.0]
  def change
    add_column :boardgames, :yearpublished, :integer
    add_column :boardgames, :minplaytime, :integer
    add_column :boardgames, :maxplaytime, :integer
  end
end
