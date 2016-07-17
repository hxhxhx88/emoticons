class CreatePackageTags < ActiveRecord::Migration
  def change
    create_table :package_tags,  :id => false do |t|
        t.uuid :id, :primary_key => true, default: "uuid_generate_v4()"
        t.uuid :package_id
        t.string :name
        t.timestamps
    end
  end
end
