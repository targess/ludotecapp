class CreateLoans < ActiveRecord::Migration[5.0]
  def change
    create_table :loans do |t|
      t.datetime :returned_at
      t.belongs_to :event
      t.belongs_to :boardgame
      t.belongs_to :player
      t.timestamps
    end
  end
end
