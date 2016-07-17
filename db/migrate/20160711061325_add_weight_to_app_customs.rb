class AddWeightToAppCustoms < ActiveRecord::Migration
  def change
    add_column :app_customs, :weight, :integer, default:0
  end
end
