require "faker"
require_relative '../utils/db'

$db_client = DBClient.new()

1000000.times do
    $db_client.exec("INSERT INTO tags (name) VALUES ($1::text)", [Faker::Name.name])
end
