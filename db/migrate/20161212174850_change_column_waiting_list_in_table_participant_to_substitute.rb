class ChangeColumnWaitingListInTableParticipantToSubstitute < ActiveRecord::Migration[5.0]
  def change
    rename_column :participants, :waiting_list, :substitute
  end
end
