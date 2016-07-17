class CreateDataStats < ActiveRecord::Migration
  def change
    create_table :data_stats,  :id => false do |t|
      t.uuid :id, :primary_key => true, default: "uuid_generate_v4()"
      t.uuid :app_id
      t.uuid :content_id
      t.string :content_type
      t.string :action
      t.datetime :timestamp
      t.integer :count
    end
    add_index :data_stats, :timestamp
  end
end
