class CreateBoardgamesPublishers < ActiveRecord::Migration[5.0]
  def change
    create_table :boardgames_publishers, id: false do |t|
      t.belongs_to :boardgame
      t.belongs_to :publisher
    end
  end
end
