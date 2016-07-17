class AddThumbUpToEmoticons < ActiveRecord::Migration
  def change
    add_column :emoticons, :thumb_up, :integer, default: 0
  end
end
