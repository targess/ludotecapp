class AddDefaultValueToSubstituteInTableParticipant < ActiveRecord::Migration[5.0]
  def change
    change_column_default :participants, :substitute, false
  end
end
