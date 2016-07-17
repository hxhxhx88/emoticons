class CreateAppConfig < ActiveRecord::Migration
  def change
    create_table :app_configs,:id => false  do |t|
      t.uuid :id, :primary_key => true, default: "uuid_generate_v4()"
      t.uuid :default_packages, array:true
      t.uuid :default_emoticons, array:true
      t.uuid :app_id
      t.timestamps
    end
  end
end
