class ChangeBarcodeLimitToBoardgame < ActiveRecord::Migration[5.0]
  def change
    change_column :boardgames, :barcode, :integer, limit: 13
  end
end
