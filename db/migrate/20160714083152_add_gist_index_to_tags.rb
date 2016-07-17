class AddGistIndexToTags < ActiveRecord::Migration
  def up

    execute <<-SQL
      CREATE INDEX tag_trgm ON tags USING GIST (name gist_trgm_ops);
    SQL
  end

  def down
    execute <<-SQL
      DROP INDEX tag_trgm;
    SQL
  end
end
