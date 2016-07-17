class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors,  :id => false  do |t|
      t.uuid :id, :primary_key => true, default: "uuid_generate_v4()"
      t.string :email
      t.boolean :email_confirm
      t.string :password_digest
      t.string :confirm_code

      t.string :phone
      t.string :id_number
      t.uuid   :id_card_front
      t.uuid   :id_card_back
      t.string :real_name
      t.string :sms_code
      t.boolean :phone_confirm
      t.integer :sms_last_send
      t.integer :account_status
      t.string :account_reject_reason

      t.string :name
      t.uuid   :avatar
      t.uuid   :home_banner
      t.string :description
      t.integer :author_status
      t.string :author_reject_reason

      t.timestamps
    end

  end
end
