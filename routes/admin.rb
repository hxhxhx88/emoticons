require 'uri'
require "slim"
require "helpers/core"
require 'slim/include'

module Emoticons
    class Admin < Grape::API
        content_type :html, "text/html"
        prefix :admin

        get "/test" do
            items = [{name: "hehe", price: 100}, {name: "haha", price: 200}]
            Slim::Template.new('public/html/test.slim').render(nil, {items: items})
        end

        get "/" do
            q = params[:q].nil? ? "" : params[:q]
            should_and = params[:rel] == "and"

            results = search_by_keywords({
                q: q,
                limit: 20,
                offset: 0,
                and: should_and,
                debug: true
            })
            
            emoticons = []
            results.each do |result|
                # $cdn_client is imported through `helpers/core`
                url = $cdn_client.medium_url(result["image_key"])

                emoticons << {
                    # Although the SQL returnes an array, in Ruby it becomes a string.
                    tags: result["tags"][1...-1],
                    url: url
                }
            end

            Slim::Template.new('public/html/index.slim').render(nil, {emoticons: emoticons, q: q, should_and: should_and})
        end
    end
end
