class AddBarcodeToBoardgame < ActiveRecord::Migration[5.0]
  def change
    add_column :boardgames, :barcode, :integer, default: 0
  end
end
