class AddRejectReasonToDevelopers < ActiveRecord::Migration
  def change
    add_column :developers, :reject_reason, :string
  end
end
