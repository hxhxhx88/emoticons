class AddPriceToPackage < ActiveRecord::Migration
  def change
    add_column :lists, :price, :Integer, default: 0 # cent
  end
end
