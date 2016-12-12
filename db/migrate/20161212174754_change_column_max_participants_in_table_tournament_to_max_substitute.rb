class ChangeColumnMaxParticipantsInTableTournamentToMaxSubstitute < ActiveRecord::Migration[5.0]
  def change
    rename_column :tournaments, :max_participants, :max_substitutes
  end
end
