class AddAuditAtAndPassAtToPackage < ActiveRecord::Migration
  def change
    add_column :lists, :audit_at, :datetime
    add_column :lists, :pass_at,  :datetime
  end
end
