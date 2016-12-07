class CreateEventsPlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :events_players, id: false do |t|
      t.belongs_to :player
      t.belongs_to :event
    end
  end
end


