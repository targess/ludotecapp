class RemoveDefaultValuesFromBarcodeAndInternalcodeToBoardgames < ActiveRecord::Migration[5.0]
  def change
    change_column_default(:boardgames, :barcode, nil)
    change_column_default(:boardgames, :internalcode, nil)
  end
end
