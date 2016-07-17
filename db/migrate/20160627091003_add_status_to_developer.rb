class AddStatusToDeveloper < ActiveRecord::Migration
  def change
    add_column :developers, :status, :integer, default: 0
  end
end
