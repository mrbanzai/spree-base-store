role :web, 'brand.linode'
role :app, 'brand.linode'
role :db,  'brand.linode', :primary => true

set :user, 'deployer'
set :runner, 'brandrpm'
set :unicorn_user, 'brandrpm'

set :use_sudo, true

set :rvm_type, :system
