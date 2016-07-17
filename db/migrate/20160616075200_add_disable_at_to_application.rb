class AddDisableAtToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :disable, :boolean , default: false
  end
end
