module Emoticons
    class Admin < Grape::API
        content_type :html, "text/html"
        prefix :admin

        get "/" do
            "<h1>Hello World</h1>"
        end
    end
end