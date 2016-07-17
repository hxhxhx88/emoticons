class CreateAppCustoms < ActiveRecord::Migration
  def change
    create_table :app_customs, :id => false  do |t|
      t.uuid :id, :primary_key => true, default: "uuid_generate_v4()"
      t.uuid :app_id
      t.string :tag_name

      t.timestamps
    end
  end
end
