require 'bundler'
Bundler.require(:default, ENV['RACK_ENV'] || :development)

require 'routes/api'
require 'routes/admin'

module Emoticons
    class Route < Grape::API
        mount Emoticons::API
        mount Emoticons::Admin
    end
end