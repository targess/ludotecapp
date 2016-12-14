class ChangeBarcodeTypeToBoardgame < ActiveRecord::Migration[5.0]
  def change
    change_column :boardgames, :barcode, :string, limit: 13
  end
end
