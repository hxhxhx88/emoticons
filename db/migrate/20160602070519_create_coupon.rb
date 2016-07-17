class CreateCoupon < ActiveRecord::Migration
  def change
    create_table :coupons, id:false do |t|
      t.uuid :id, :primary_key => true, default: "uuid_generate_v4()"
      t.string :sn, :index => true
      t.boolean :active
      t.uuid :developer_id
      t.integer :amount
      t.boolean :binding
      t.datetime :expire_at
      t.datetime :active_at
      t.timestamps
    end
  end
end
