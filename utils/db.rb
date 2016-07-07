require 'pg'
require_relative '../secrets'

class DBClient
    def initialize
        @conn = PG.connect(
            dbname: Secrets::DB::DBNAME,
            host: Secrets::DB::HOST,
            port: Secrets::DB::PORT,
            user: Secrets::DB::USER,
            password: Secrets::DB::PASSWORD,
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
