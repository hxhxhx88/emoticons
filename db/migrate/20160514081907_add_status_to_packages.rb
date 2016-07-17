class AddStatusToPackages < ActiveRecord::Migration
  def change
    add_column :lists,  :status, :integer
  end
end
