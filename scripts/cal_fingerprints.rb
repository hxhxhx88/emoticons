# This scripts will calculate and store fringerprints for ALL emoticons in the database.

require 'uri'
require "open-uri"
require "phashion"
require "colorize"

require_relative '../helpers/files'
require_relative '../utils/db'
require_relative '../utils/cdn'

$db_client = DBClient.new()
$cdn_client = CDNClient.new()

def calculate_fingerprint_by_filename(filename)
    img = Phashion::Image.new(filename)
    fingerprint = img.fingerprint()

    # Since in PostgreSQL, bigint is 64-bit signed int, and unsigned int is not supported, we manually convert
    # the fingerprint, which is a 64-bit unsigned int, into signed one.
    fingerprint -= 2 ** 64 if fingerprint >= (2 ** 63)
    fingerprint
end

def calculate_fingerprint(image_url)
    # Calcualte the fingerprint of a single image, and return it.

    # Since we are using phashion, which can only be feed by a filename, so we download and write the image to a temp file.
    uri = URI.parse(image_url)
    filename = File.basename(uri.path)
    tmp_file = "tmp/#{filename}"

    ensure_can_write_file(tmp_file)
    File.open(tmp_file, 'wb') do |f|
      f.write open(image_url).read
    end

    fingerprint = calculate_fingerprint_by_filename(tmp_file)

    # delete the tmp file
    File.delete(tmp_file)

    return filterprint
end

def calculate_all()
    count = $db_client.fetch_one("SELECT COUNT(*) FROM images")["count"]

    puts "#{count} images to go...".yellow

    log_path = "log/finerprint.log"
    ensure_can_write_file(log_path)
    log_file = File.open(log_path, "w")

    idx = 0
    $db_client.fetch_many("SELECT id, key FROM images WHERE fingerprint IS NULL") do |row| 
        begin
            image_url = $cdn_client.full_url(row["key"])
            fingerprint = calculate_fingerprint(image_url)
            $db_client.exec("UPDATE images SET fingerprint = $1::bigint WHERE id = $2::uuid", [fingerprint, row["id"]])
        rescue Exception => e
            msg = "#{e.message}. Image: #{image_url}"
            puts msg.red
            log_file.write msg
        end

        # print log
        idx += 1
        puts "#{idx}/#{count} finished".green if idx % 10 == 0
    end
    
    log_file.close()
end

if __FILE__ == $0
    calculate_all()
end
