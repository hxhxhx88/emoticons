class AddInfoToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :app_type, :string
    add_column :applications, :description, :string
    add_column :applications, :icon_id, :uuid
  end
end
