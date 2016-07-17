class AddWeightToPackageTags < ActiveRecord::Migration
  def change
    add_column :package_tags, :weight, :integer, default:0
  end
end
