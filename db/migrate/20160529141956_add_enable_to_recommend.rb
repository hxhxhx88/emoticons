class AddEnableToRecommend < ActiveRecord::Migration
  def change
    add_column :recommends, :enable, :boolean
  end
end
