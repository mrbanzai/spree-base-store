role :web, 'brand.linode'
role :app, 'brand.linode'
role :db,  'brand.linode', :primary => true

set :user, 'brandrpm'
set :runner, 'brandrpm'

set :use_sudo, false

set :bundle_cmd, '/usr/local/bin/bundle'

# Very long, expressive path
set(:store_type_root) { "/srv/apps/brandrpm/#{store_type}" }
