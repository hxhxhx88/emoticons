class AddWeightToPackage < ActiveRecord::Migration
  def change
    add_column :lists, :weight, :integer
  end
end
