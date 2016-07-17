class CreateBalance < ActiveRecord::Migration
  def change
    create_table :balances, id:false do |t|
      t.uuid :id, :primary_key => true, default: "uuid_generate_v4()"
      t.string :type
      t.integer :amount
      t.uuid :developer_id
      t.timestamps
    end
  end
end
