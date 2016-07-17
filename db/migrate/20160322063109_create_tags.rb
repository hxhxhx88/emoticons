class CreateTags < ActiveRecord::Migration
  def change
        create_table :tags,  :id => false do |t|
          t.uuid :id, :primary_key => true, default: "uuid_generate_v4()"
          t.uuid :tag_type_id
          t.integer :weight
          t.string :name
          t.timestamps
        end
        add_index :tags, :name
  end
end
