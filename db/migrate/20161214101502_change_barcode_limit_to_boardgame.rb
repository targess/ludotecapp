class ChangeBarcodeLimitToBoardgame < ActiveRecord::Migration[5.0]
  def change
    change_column :boardgames, :barcode, :string
  end
end
