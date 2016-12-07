class CreateBoardgamesEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :boardgames_events, id: false do |t|
      t.belongs_to :boardgame
      t.belongs_to :event
    end
  end
end
