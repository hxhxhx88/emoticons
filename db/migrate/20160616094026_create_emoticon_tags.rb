class CreateEmoticonTags < ActiveRecord::Migration
  def change
    create_table :emoticons_tags, :id => false  do |t|
      t.uuid :id, :primary_key => true, default: "uuid_generate_v4()"
      t.uuid :emoticon_id
      t.uuid :tag_id
      t.timestamps
    end
  end
end
