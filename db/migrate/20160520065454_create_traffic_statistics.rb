class CreateTrafficStatistics < ActiveRecord::Migration
  def change
    create_table :traffic_statistics,:id => false  do |t|
      t.uuid :id, :primary_key => true, default: "uuid_generate_v4()"
      t.bigint :count
      t.uuid :app_id
      t.datetime :timestamp
    end

  end
end
