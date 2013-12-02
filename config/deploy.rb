# -*- encoding : utf-8 -*-
set :hipchat_token, "hipchat token goes here"
set :hipchat_room_name, "hrguru"
set :hipchat_announce, false

task :production do
  set :stage, 'production'
  set :webserver, "production server name goes here"
end

set :application, "hrguru"

set :rvm_ruby_string, "2.0.0-p247"

set :gateway, "myuser@somegateawayserver.com" unless exists?(:gateway)
set :webserver, "staging.server.name.com"

require 'netguru/capistrano'

after "deploy:update_code", "netguru:precompile"
