class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists,  :id => false  do |t|
      t.uuid :id, :primary_key => true, default: "uuid_generate_v4()"
      t.string :name
      t.uuid :contents, array:true
      t.uuid :cover
      t.timestamps
      t.string :type
      t.boolean :enable

      t.uuid :user_id
      t.uuid :fork_from

      t.uuid :author_id
      t.string :description
      t.string :sub_title
      t.uuid :background
    end
  end
end
