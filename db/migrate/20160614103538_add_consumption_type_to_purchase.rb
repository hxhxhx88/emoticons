class AddConsumptionTypeToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :consumption_type, :string
  end
end
