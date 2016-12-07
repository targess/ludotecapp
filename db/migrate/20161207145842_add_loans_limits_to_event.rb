class AddLoansLimitsToEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :loans_limits, :integer, default: 0
  end
end
