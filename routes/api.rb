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
            # 4) Naively, we may write the query like this:
            #   SELECT
            #       et.emoticon_id
            #   FROM emoticons_tags AS et
            #   JOIN tags AS t ON et.tag_id = t.id AND t.name % '哈哈'
            #   ORDER BY et.emoticon_id
            #   LIMIT 8;
            # However, it turns out to be VERY SLOW, since PG can not utilize the index on et.tag_id, which will result in a seq scan.
            #
            # 5) Then, it is natural to think to change the query to
            #   SELECT
            #     et.emoticon_id
            #   FROM emoticons_tags AS et
            #   WHERE et.tag_id IN (SELECT id FROM tags AS t WHERE t.name % '哈哈')
            #   ORDER BY et.emoticon_id
            #   LIMIT 8;
            # since we know where clause like `WHERE et.tag_id IN ('xxx')` will trigger the index. However, the above query does not, since
            # the set of IN clause is not a constant. We have to make it into a constant. Finally, the query is optimized to
            #   SELECT
            #       et.emoticon_id
            #   FROM emoticons_tags AS et
            #   WHERE et.tag_id = ANY(
            #       (
            #           SELECT
            #               ARRAY(
            #                   SELECT id FROM tags AS t WHERE t.name % 'Natasha'
            #               )
            #           )::uuid[]
            #       )
            #   ORDER BY et.emoticon_id
            #   LIMIT 8;
            # Please refer to
            #  http://stackoverflow.com/questions/14987321/postgresql-in-operator-with-subquery-poor-performance
            #
            # (6) The ORDER BY clause is NECESSORY! Without it, a single LIMIT clause will make the query VERY SLOW, especially when the matched
            # tags are empty. Please refer to
            #  http://stackoverflow.com/questions/21385555/postgresql-query-very-slow-with-limit-1
            #
            # (7) If the query is still slow, try to reindex the index on et.tag_id, e.g.
            #  REINDEX INDEX emoticons_tags_ids_idx

            # Split keywords and form the WHERE clause in the SQL
            qs = params[:q].split(',')
            where_clauses = []
            q_params = []
            qs.each_with_index do |keyword, idx|
                where_clauses << "t.name % $#{idx + 1}::text"
                q_params << keyword
            end

            where_clause = params[:and] ? where_clauses.join(' AND ') : where_clauses.join(' OR ')
            p where_clause
            q_params += [params[:limit], params[:offset]]

            query = "\
                SELECT \
                    e.id AS emoticon_id, \
                    i.id AS image_id, \
                    i.key AS image_key \
                FROM emoticons_tags AS et \
                JOIN emoticons AS e ON e.id = et.emoticon_id \
                JOIN images AS i ON e.image_id = i.id \
                WHERE et.tag_id = ANY( \
                    ( \
                        SELECT \
                            ARRAY( \
                                SELECT id FROM tags AS t WHERE #{where_clause} \
                            ) \
                    )::uuid[] \
                ) \
                ORDER BY et.emoticon_id \
                LIMIT $#{q_params.length - 1}::integer \
                OFFSET $#{q_params.length}::integer \
            "

            # Fetch the results.
            results = []
            $db_client.fetch_many(query, q_params) do |result|
                results << result.to_h
            end
            if params[:debug]

                results.each do |item|
                    query= "\
                        SELECT name FROM tags JOIN emoticons_tags AS et ON et.emoticon_id = '#{item["emoticon_id"]}'\
                        where tags.id = et.tag_id\
                    "
                    item["tags"]=[]
                    item["url"]=$cdn_client.full_url(item["image_key"])
                    $db_client.fetch_many(query) do |result|
                        item["tags"] << result["name"]
                    end
                end
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
