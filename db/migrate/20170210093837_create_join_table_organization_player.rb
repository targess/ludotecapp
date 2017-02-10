class CreateJoinTableOrganizationPlayer < ActiveRecord::Migration[5.0]
  def change
    create_join_table :organizations, :players do |t|
      # t.index [:organization_id, :player_id]
      # t.index [:player_id, :organization_id]
    end
  end
end
