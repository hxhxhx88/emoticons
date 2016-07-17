class CreateUploadRecords < ActiveRecord::Migration
  def change
    create_table :upload_records, :id => false do |t|
      t.uuid :id, :primary_key => true, default: "uuid_generate_v4()"
      t.uuid :user_id
      t.uuid :image_id
      t.datetime :created_at
    end
  end
end
