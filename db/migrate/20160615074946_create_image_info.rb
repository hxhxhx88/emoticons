class CreateImageInfo < ActiveRecord::Migration
  def change
    create_table :emoticons, id: false do |t|
      t.uuid :id, :primary_key => true, default: "uuid_generate_v4()"
      t.string :description
      t.integer :collect
      t.integer :share
      t.timestamps
      t.uuid :image_id
    end
  end
end
