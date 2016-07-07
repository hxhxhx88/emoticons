require 'utils/db'
$db_client = DBClient.new()

require 'utils/cdn'
$cdn_client = CDNClient.new()

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

        desc "Search similar images based on the content of given image."
        params do
            requires :image, type: File
        end
        get "/similar" do
            return {
                emoticons: [
                    "1",
                    "2"
                ]
            }
        end
    end
end
