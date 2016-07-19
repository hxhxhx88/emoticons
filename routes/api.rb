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
           optional :debug, type:Boolean, default:true, desc:"Show emoticons tags detail and url"
        end
        get "/search" do
            # There are many points about this single piece of query.
            #
            # 1) Need to install pg_trgm extension by
            #   CREATE EXTENSION pg_trgm
            # The documentation is here:
            #   https://www.postgresql.org/docs/9.5/static/pgtrgm.html.
            # However, if we find it not work with Chinese, e.g. the query
            #   SELECT show_trgm('哈哈哈')
            # returns an empty set, we have to modify the source code and build the PostgreSQL from the source.
            # Download the source files, locate contrib/pg_trgm/trgm.h, and comment out the line
            #   #define KEEPONLYALNUM
            # It seems that by default pg_trgm only recognize alphabet letters and numbers. Strangely, it seems to work on Ubuntu through
            # apt-get, but at least fails on my Mac.
            #
            # 2) When doing fuzzy match using pg_trgm, we MUST use '%' oprerator to utilize the GIST index. Do NOT write query like
            #   name <-> '哈哈' < 0.1
            # Instead, write
            #   name % '哈哈'
            # However, the '%' operator use show_limit() as threshold, which can be changed by set_limit().
            # Please refer to the doc for detail. Besides, about the behavior of index, please refer to
            #   http://stackoverflow.com/questions/11249635/finding-similar-strings-with-postgresql-quickly
            # as well.
            # BTW, create the GIST index using statement like
            #  CREATE INDEX tag_trgm ON tags USING GIST (name gist_trgm_ops);
            # as mentioned in the doc.
            #
            # 3) Should create an index on emoticons_tags.tag_id, something like
            #  CREATE UNIQUE INDEX emoticons_tags_ids_idx ON emoticons_tags (tag_id, emoticon_id);
            #
            # 4) The ORDER BY clause is NECESSORY! Without it, a single LIMIT clause will make the query VERY SLOW, especially when the matched
            # tags are empty. Please refer to
            #  http://stackoverflow.com/questions/21385555/postgresql-query-very-slow-with-limit-1
            #
            # 5) If the query is still slow, try to reindex the index on et.tag_id, e.g.
            #  REINDEX INDEX emoticons_tags_ids_idx
            #
            # 6) To enable fast debug query, you should add index on emoticon_id of emoticons_tags, e.g.
            #  CREATE INDEX emoticons_tags_emoticon_id_idx ON emoticons_tags (emoticon_id);
            #
            # 7) A typical whole query will look like the following, from which hopefully you can see what I am doing:
            # WITH hits AS (
            #     SELECT
            #         e.id AS emoticon_id,
            #         e.image_id AS image_id,
            #         MIN(t.name <-> 'C罗') AS distance
            #     FROM emoticons AS e
            #     JOIN emoticons_tags AS et ON et.emoticon_id = e.id
            #     JOIN tags AS t ON t.id = et.tag_id AND t.name % 'C罗'
            #     GROUP BY e.id
            #
            #     UNION ALL
            #   
            #     SELECT
            #         e.id AS emoticon_id,
            #         e.image_id AS image_id,
            #         MIN(t.name <-> '中文') AS distance
            #     FROM emoticons AS e
            #     JOIN emoticons_tags AS et ON et.emoticon_id = e.id
            #     JOIN tags AS t ON t.id = et.tag_id AND t.name % '中文'
            #     GROUP BY e.id
            # )
            # SELECT
            #     h.emoticon_id,
            #     (SUM(h.distance) + 1 * (2 - COUNT(h.distance)))/ 2 AS distance,
            #     MAX(i.key) AS image_key,
            #     ARRAY(
            #         SELECT
            #             t.name
            #         FROM tags AS t
            #         JOIN emoticons_tags AS et ON et.tag_id = t.id
            #         WHERE et.emoticon_id = h.emoticon_id
            #     ) AS tags
            # FROM hits AS h
            # JOIN images AS i ON h.image_id = i.id
            # GROUP BY h.emoticon_id
            # ORDER BY distance
            # LIMIT 20
            # OFFSET 0;


            # Split keywords and form the WHERE clause in the SQL
            qs = params[:q].split(',')

            # The query template for a single match
            query_for_single_match = "\
                SELECT \
                    e.id AS emoticon_id, \
                    e.image_id AS image_id, \
                    MIN(t.name <-> %s) AS distance \
                FROM emoticons AS e \
                JOIN emoticons_tags AS et ON et.emoticon_id = e.id \
                JOIN tags AS t ON t.id = et.tag_id AND t.name %% %s \
                GROUP BY e.id \
            "

            q_params = []
            
            matches = []
            qs.each_with_index do |keyword, idx|
                matches << (query_for_single_match % ["$#{idx * 2 + 1}::text", "$#{idx * 2 + 2}::text"])
                q_params << keyword
                q_params << keyword
            end

            sub_query = matches.join("UNION ALL")
            having_clause = params[:and] ? "HAVING COUNT(h.emoticon_id) = #{qs.length}" : ""

            tags_query = ""
            if params[:debug]
                # Note the leading comma!
                tags_query = "\
                    , \
                    ARRAY( \
                        SELECT \
                            t.name \
                        FROM tags AS t \
                        JOIN emoticons_tags AS et ON et.tag_id = t.id \
                        WHERE et.emoticon_id = h.emoticon_id \
                    ) AS tags \
                "
            end

            q_params += [params[:limit], params[:offset]]
            query = "\
                WITH hits AS ( \
                    #{sub_query} \
                ) \
                SELECT \
                    h.emoticon_id, \
                    (SUM(h.distance) + 1 * (#{qs.length} - COUNT(h.distance))) / #{qs.length} AS distance, \
                    MAX(i.key) AS image_key \
                    #{tags_query}
                FROM hits AS h \
                JOIN images AS i ON h.image_id = i.id \
                GROUP BY h.emoticon_id \
                #{having_clause}
                ORDER BY distance
                LIMIT $#{q_params.length - 1}::integer \
                OFFSET $#{q_params.length}::integer \
            "

            # Fetch the results.
            results = []
            $db_client.fetch_many(query, q_params) do |result|
                results << result.to_h
            end

            {
                results: results
            }
        end

        # This API requires to install a PostgreSQL extension called pg_similarity, which can be downloaded from
        #   http://pgsimilarity.projects.pgfoundry.org/
        # Although it does not use an index, there seems to be some kind of optimization for fast look up, since using EXPLAIN
        # we see that a simple SELECT through 9000 records filtered by hamming distances only scans 3000 rows.
        # Also, the fingerprints of all images in the database should be pre-calcuated. I write a scrpt in scripts/cal_fingerprints.rb
        # for this.
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
                    i.id AS image_id, \
                    i.key AS image_key, \
                    #{hamming_distance} AS dist \
                FROM images AS i \
                WHERE #{hamming_distance} <= $2 \
                ORDER BY dist ASC \
            "
            q_params = [fingerprint, hamming_threshold]

            # Fetch the results.
            results = []
            $db_client.fetch_many(query, q_params) do |result|
                results << result.to_h
            end

            return {
                results: results
            }
        end
    end
end
