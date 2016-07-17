class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses, :id => false  do |t|
      t.uuid :id, :primary_key => true, default: "uuid_generate_v4()"
      t.string :location
      t.string :phone
      t.string :name
      t.string :zip_code
      t.boolean :default
      t.uuid :developer_id
      t.timestamps
    end
  end
end
