require 'pg'
require 'secrets'

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

    def fetch_many(query)
        @conn.exec(query) do |result|
            result.each do |row|
                yield row
            end
        end
    end

    def fetch_one(query)
        # Return a hash of the first row, or nil if the result is empty.
        @conn.exec(query).first
    end

    def exec(query)
        @conn.exec(query) 
    end
end
