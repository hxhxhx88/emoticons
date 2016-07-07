require "slim"

module Emoticons
    class Admin < Grape::API
        content_type :html, "text/html"
        prefix :admin

        get "/" do
            items = [{name: "hehe", price: 100}, {name: "haha", price: 200}]
            Slim::Template.new('public/html/hello.slim').render(nil, {items: items})
        end
    end
end
