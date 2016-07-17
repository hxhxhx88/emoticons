class AddThumbnailToEmoticons < ActiveRecord::Migration
  def change
    add_column :emoticons, :thumb_id, :uuid
  end
end
