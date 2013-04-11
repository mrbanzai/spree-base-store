role :web, 'brand.linode'
role :app, 'brand.linode'
role :db,  'brand.linode', :primary => true

set :user, 'brandrpm'
set :runner, 'brandrpm'

set :use_sudo, false

set :bundle_cmd, '/usr/local/bin/bundle'

set :rails_env, 'production'

set(:deploy_to) { "/srv/apps/brandrpm/#{rails_env}/#{application}" }

after 'deploy:setup',           'db:setup'
after 'deploy:finalize_update', 'db:symlink'
