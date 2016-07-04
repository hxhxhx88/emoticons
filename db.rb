require 'pg'

class DBClient
    def initialize
        @conn = PG.connect( dbname: 'emoticons' )
    end

    def fetch_many(query)
        @conn.exec(query) do |result|
            result.each do |row|
                yield row
            end
        end
    end

    def fetch_one(query)
        @conn.exec(query).values.first
    end

    def exec(query)
        @conn.exec(query) 
    end
end
