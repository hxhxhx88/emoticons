class CreateInvoice < ActiveRecord::Migration
  def change
    create_table :invoices, id:false do |t|
      t.uuid :id, :primary_key => true, default: "uuid_generate_v4()"
      t.uuid :developer_id
      t.string :address
      t.integer :state
      t.string :title
      t.integer :amount
      t.string :express_id
      t.string :express_name

      t.timestamps
    end
  end
end
