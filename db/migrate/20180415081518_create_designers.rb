class CreateDesigners < ActiveRecord::Migration[5.0]
  def change
    create_table :designers do |t|
      t.string :name
      t.integer :bgg_id
    end
  end
end
