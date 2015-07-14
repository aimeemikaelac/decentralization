# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)

#use OmniAuth::Builder do
#  provider :digitalocean, SETTINGS['CLIENT_ID'], SETTINGS['CLIENT_SECRET'], scope: "read write"
#end

#Rails.application.config.middleware.use OmniAuth::Builder do
#  require 'openid/store/filesystem' 
#  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
#  provider :openid, :store => OpenID::Store::Filesystem.new('/tmp')
#end

run Rails.application
