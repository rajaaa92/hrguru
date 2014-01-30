# -*- encoding : utf-8 -*-
task :production do
  set :stage, 'production'
  set :webserver, "netguru.p.netguru.co"
end

set :application, "hrguru"
set :skip_migrations, true

set :rvm_ruby_string, "2.0.0-p353"

set :gateway, "hrguru@s.netguru.co" unless exists?(:gateway)
set :webserver, "s.netguru.co"

after "deploy:update_code", "netguru:precompile"
