class CreateAdministrator < ActiveRecord::Migration
  def change
    create_table :administrators,:id => false  do |t|
      t.uuid :id, :primary_key => true, default: "uuid_generate_v4()"
      t.string :email
      t.string :password_digest
      t.string :real_name
      t.uuid :user_id
    end

  end
end
