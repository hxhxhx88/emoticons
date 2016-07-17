class CreatePurchases < ActiveRecord::Migration
  def change
      create_table :purchases,  id:false do |t|
        t.uuid :id, :primary_key => true, default: "uuid_generate_v4()"
        t.integer :amount
        t.string :type
        t.string  :description
        t.uuid :developer_id
        t.timestamps
      end
  end
end
