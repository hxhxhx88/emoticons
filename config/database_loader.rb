root_path = File.expand_path('../..', __FILE__)
Grape::ActiveRecord.configure_from_file!(File.join(root_path, 'config', 'database.yml'))
ActiveRecord::Base.connection_pool.with_connection do
  # ActiveUUID::Patches.apply!
end
require 'qiniu'

