class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications, :id => false do |t|
      t.uuid :id, :primary_key => true, default: "uuid_generate_v4()"
      t.string :name
      t.string :access_key
      t.string :secret_key
      t.string  :reset_code
      t.datetime :reset_code_expire
      t.string  :view_code
      t.datetime :view_code_expire
      t.uuid :developer_id
      t.timestamps
    end
  end
end
