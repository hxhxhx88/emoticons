# TODO: phashion is stupid enough to only accept filename as parameter, improve it.

require "phashion"

require 'utils/db'
$db_client = DBClient.new()

require 'utils/cdn'
$cdn_client = CDNClient.new()

require 'scripts/cal_fingerprints'

module Emoticons
    class API < Grape::API
        format :json
        prefix :api
        
        desc "Search emoticons by keywords"
        params do
           requires :q, type: String, desc:'The query string, should be separated by commas(,).'
           optional :limit, type: Integer, default:8, desc:'The Limit.'
           optional :offset,  type: Integer, default:0, desc:'The offset.'
           optional :and, type: Boolean, default:true, desc:'Flag to use `and` or `or` as the relationship between keywords.'
           optional :advanced, type: Boolean, default:true, desc:"Flag to use advanced mode."
        end
        get "/search" do
            return {
                emoticons: [
                    "1",
                    "2"
                ]
            }
        end

        # This API requires to install a PostgreSQL extension called pg_similarity, which can be downloaded from
        #   http://pgsimilarity.projects.pgfoundry.org/
        # Although it does not use an index, there seems to be some kind of optimization for fast look up, since using EXPLAIN
        # we see that a simple SELECT through 9000 records filtered by hamming distances only scans 3000 rows.
        desc "Search similar images based on the content of given image."
        params do
            requires :image, type: File
        end
        post "/similar" do
            # Save the passed file to a tempfile, and use the path as the parameter to create a Phashion::Image instance.
            fingerprint = calculate_fingerprint_by_filename(params.image.tempfile.path)

            # Stupid enough, the pg_similarity extension calculates the `hamming similarity` instead of `hamming distance`
            # of two binary codes, i.e. the returned value of the `hamming` function is `1 - hamming_distance`, so 1 means
            # very similary, and 0 means totally different. In fact, the hamming_distance is the number of differnt bits divided
            # by the length of the bits.
            hamming_distance = "1.0 - hamming(i.fingerprint::bit(64), ($1::bigint)::bit(64))"

            # We use 10.0 / 64.0 as the threshold to determine duplicated images, which is based on expirements.
            hamming_threshold = 10.0 / 64.0

            # We do not do paginaton on this API, since the results are expected to be not to many.
            query = "\
                SELECT \
                    i.id, \
                    i.key, \
                    #{hamming_distance} AS dist \
                FROM images AS i \
                WHERE #{hamming_distance} <= $2 \
                ORDER BY dist ASC \
            "
            params = [fingerprint, hamming_threshold]
            
            # Fetch the results.
            results = []
            $db_client.fetch_many(query, params) do |result|
                results << result.to_h
            end

            return {
                results: results
            }
        end
    end
end
