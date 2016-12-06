class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.string :dni
      t.string :firstname
      t.string :lastname
      t.string :city
      t.string :province
      t.date :birthday
      t.string :email
      t.integer :phone

      t.timestamps
    end
  end
end
