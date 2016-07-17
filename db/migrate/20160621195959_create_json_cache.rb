class CreateJsonCache < ActiveRecord::Migration
    def change
      create_table :json_caches , :id => false  do |t|
        t.uuid :id, :primary_key => true, default: "uuid_generate_v4()"
        t.json :content
        t.datetime :expire
        #author
      end
    end

end
