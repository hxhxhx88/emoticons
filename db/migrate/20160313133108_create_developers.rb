class CreateDevelopers < ActiveRecord::Migration
  def change
    create_table :developers , :id => false  do |t|
      t.uuid :id, :primary_key => true, default: "uuid_generate_v4()"
      t.string :email
      t.string :phone
      t.string :password_digest
      t.boolean :confirm
      t.string :state #账号状态

      t.string :confirm_code
      t.string :address
      t.string :qq
      t.string :personal_id
      t.string :real_name
      t.string :phone_check

      t.boolean :is_org
      t.string :org_name
      t.string :org_site
      t.uuid :org_license_id

      t.uuid :profile_id
      t.uuid :profile_back_id
      t.datetime :phone_check_code_time
      t.timestamps
    end
  end
end
