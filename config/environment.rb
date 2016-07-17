require 'bundler'
require 'yaml'
ENV["RACK_ENV"]||="development"
Bundler.require(:default, ENV['RACK_ENV'] || :development)
# initialize log
require 'logger'
root_path = File.expand_path('../..', __FILE__)

Dir.mkdir(root_path+'/log') unless File.exist?(root_path+'/log')
class ::Logger; alias_method :write, :<<; end
case ENV["RACK_ENV"]
  when "production"
    logger = ::Logger.new(root_path+"/log/production.log")
    logger.level = ::Logger::INFO
  when "development"
     logger = ::Logger.new(STDOUT)
    # logger = ::Logger.new(root_path+"/log/development.log")
     logger.level = ::Logger::DEBUG
  else
    logger = ::Logger.new("/dev/null")
end

ActiveRecord::Base.logger = logger

require_relative('./database_loader')

