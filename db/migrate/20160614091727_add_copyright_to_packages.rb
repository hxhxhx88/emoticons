class AddCopyrightToPackages < ActiveRecord::Migration
  def change
    add_column :lists, :copyright, :string
  end
end
