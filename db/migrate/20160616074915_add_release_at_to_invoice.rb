class AddReleaseAtToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :release_at, :date
  end
end
