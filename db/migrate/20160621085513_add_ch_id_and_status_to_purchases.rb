class AddChIdAndStatusToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :ch_id, :string
    add_column :purchases, :status, :integer, default: 0
  end
end
