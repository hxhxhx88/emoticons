class AddIndexToEmoticonsTagsTable < ActiveRecord::Migration
  def up

    execute <<-SQL
      CREATE UNIQUE INDEX emoticons_tags_ids_idx ON emoticons_tags (tag_id, emoticon_id);
    SQL
  end

  def down
    execute <<-SQL
      DROP INDEX emoticons_tags_ids_idx;
    SQL
  end
end
