class AddDescriptionToCoupon < ActiveRecord::Migration
  def change
    add_column :coupons, :description, :string
  end
end
