class CreateBoardgames < ActiveRecord::Migration[5.0]
  def change
    create_table :boardgames do |t|
      t.string :name
      t.string :thumbnail
      t.string :image
      t.text :description
      t.integer :minplayers
      t.integer :maxplayers
      t.integer :playingtime
      t.integer :minage
      t.integer :bgg_id

      t.timestamps
    end
  end
end
