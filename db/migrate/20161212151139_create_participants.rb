class CreateParticipants < ActiveRecord::Migration[5.0]
  def change
    create_table :participants do |t|
      t.boolean :confirmed
      t.boolean :waiting_list
      t.references :player, foreign_key: true
      t.references :tournament, foreign_key: true

      t.timestamps
    end
  end
end
