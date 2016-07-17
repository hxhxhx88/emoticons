class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, :id => false do |t|
      t.uuid :contents, array:true
      t.uuid :app_id
      t.uuid :id, :primary_key => true, default: "uuid_generate_v4()"
      t.string :auth_token
      t.integer :role_mask
      t.timestamps
    end
  end
end
