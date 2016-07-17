class AddOrderNoToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :order_no, :string
  end
end
