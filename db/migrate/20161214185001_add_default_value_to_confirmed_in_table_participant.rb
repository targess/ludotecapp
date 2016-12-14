class AddDefaultValueToConfirmedInTableParticipant < ActiveRecord::Migration[5.0]
  def change
    change_column_default :participants, :confirmed, false
  end
end
