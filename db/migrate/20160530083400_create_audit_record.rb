class CreateAuditRecord < ActiveRecord::Migration
  def change
    create_table :audit_records, :id => false  do |t|
      t.uuid :id, :primary_key => true, default: "uuid_generate_v4()"
      t.uuid :target_id, null:false
      t.string :type
      t.boolean :pass
      t.string :message
      t.uuid :operator_id, null:false
      t.timestamps
    end

  end
end
