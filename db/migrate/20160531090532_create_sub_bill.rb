class CreateSubBill < ActiveRecord::Migration
  def change
    create_table :sub_bills, id: false do |t|
      t.uuid :id, :primary_key => true, default: "uuid_generate_v4()"
      t.uuid :bill_id
      t.string :type
      t.integer :amount
      t.bigint  :count
      t.integer :level
      t.timestamps
    end
  end
end
