class CreateImages < ActiveRecord::Migration
  def change
    create_table :images, :id => false  do |t|
      t.uuid :id, :primary_key => true, default: "uuid_generate_v4()"
      t.string :key
      t.integer :fsize
      t.integer :height
      t.integer :width
      t.string :format
      t.string :md5
      t.string :type
      t.timestamps
    end
    #add_index :images, :key, unique: true

  end
end
