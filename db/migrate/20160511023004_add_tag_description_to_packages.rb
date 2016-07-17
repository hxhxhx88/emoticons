class AddTagDescriptionToPackages < ActiveRecord::Migration
  def change
    add_column :lists, :tag_description, :string
  end
end
