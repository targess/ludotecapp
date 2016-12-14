class AddInternalcodeToBoardgame < ActiveRecord::Migration[5.0]
  def change
    add_column :boardgames, :internalcode, :string, default: 0
  end
end
