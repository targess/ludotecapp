class CreateTournaments < ActiveRecord::Migration[5.0]
  def change
    create_table :tournaments do |t|
      t.string :name
      t.integer :max_participants
      t.integer :max_competitors
      t.datetime :date
      t.integer :minage
      t.references :boardgame, foreign_key: true
      t.references :event, foreign_key: true

      t.timestamps
    end
  end
end
