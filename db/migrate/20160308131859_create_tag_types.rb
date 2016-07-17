class CreateTagTypes < ActiveRecord::Migration
  def change
    create_table :tag_types ,:id => false do |t|
      t.uuid :id, :primary_key => true, default: "uuid_generate_v4()"
      t.string :name
      t.timestamps
    end
    add_index :tag_types, :name
  end
end
