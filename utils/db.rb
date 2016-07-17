require 'pg'
require_relative '../secrets'

class DBClient
    def initialize
        root_path = File.expand_path('../..', __FILE__)
        config=YAML.load_file(File.join(root_path, 'config', 'database.yml'))[ENV["RACK_ENV"]]
        @conn = PG.connect(
            dbname: config["database"],
            host: config["host"],
            port: config["port"],
            user: config["username"],
            password: config["password"],
        )
    end

    def fetch_many(query, params=[])
        @conn.exec_params(query, params) do |result|
            result.each do |row|
                yield row
            end
        end
    end

    def fetch_one(query, params=[])
        # Return a hash of the first row, or nil if the result is empty.
        @conn.exec_params(query, params).first
    end

    def exec(query, params=[])
        @conn.exec_params(query, params)
    end
end
