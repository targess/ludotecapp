class CreateBoardgamesDesigners < ActiveRecord::Migration[5.0]
  def change
    create_table :boardgames_designers do |t|
      t.belongs_to :boardgame
      t.belongs_to :designer
    end
  end
end
