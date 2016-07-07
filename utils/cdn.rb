require 'qiniu'
require_relative '../secrets'

class CDNClient
    BUCKET = 'facehub'
    PRIVATE_URL = 'http://7tsytb.com2.z0.glb.qiniucdn.com'
    EXPIRES_IN = 3600 * 12

    def initialize
        Qiniu.establish_connection! :access_key => Secrets::Qiniu::ACCESS_KEY, :secret_key => Secrets::Qiniu::SECRET_KEY
    end

    def full_url(key)
        _gen_url(key)
    end

    def medium_url(key)
        _gen_url(key + "!medium")
    end

    private

    def _gen_url(key)
        Qiniu::Auth.authorize_download_url(PRIVATE_URL + '/' + key, {expires_in: EXPIRES_IN})
    end
end

if __FILE__ == $0
    cdn_client = CDNClient.new()

    ARGV.each do |a|
        p cdn_client.full_url(a)
    end    
end
