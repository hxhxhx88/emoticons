class CreateApiCounters < ActiveRecord::Migration
  def change
    create_table :api_counters,:id => false do |t|
      t.uuid :id, :primary_key => true, default: "uuid_generate_v4()"
      t.uuid :app_id
      t.string :method
      t.datetime :timestamp
      t.integer :count
    end
  end
end
