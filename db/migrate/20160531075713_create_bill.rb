class CreateBill < ActiveRecord::Migration
  def change
    create_table :bills, id: false do |t|
      t.uuid :id, :primary_key => true, default: "uuid_generate_v4()"
      t.uuid :developer_id
      t.date :start
      t.date :end
      t.string :type




      t.integer :state
      t.integer :amount
      t.bigint :traffic_count
      t.integer :get_usage
      t.integer :other_usage
      t.timestamps
    end
  end
end
