class CreateRecommend < ActiveRecord::Migration
  def change
    create_table :recommends , :id => false  do |t|
    t.uuid :id, :primary_key => true, default: "uuid_generate_v4()"
      t.json :contents
      t.datetime :publish_at
      t.timestamps
      #author
    end
  end
end
