require 'bundler'
require 'config/environment'

require 'routes/api'
require 'routes/admin'

module Emoticons
    class Route < Grape::API
        mount Emoticons::API
        mount Emoticons::Admin
    end
end
