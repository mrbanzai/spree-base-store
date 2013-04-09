set :repository,  'git@github.com:mrbanzai/spree-base-store.git'
set :scm, 'git'
set :checkout, 'export'
set :application, 'test.brandrpm.com'

set :ssh_options, { :forward_agent => true }
default_run_options[:pty] = true
set :keep_releases, 5

set :store_type, 'master'

set(:deploy_to) { "#{store_type_root}/#{application}" }

set :stages, ['testing', 'staging', 'production']
set :default_stage, 'production'
require 'capistrano/ext/multistage'

require 'bundler/capistrano'
set :bundle_flags, '--deployment --quiet --binstubs'

require 'capistrano-unicorn'
#after 'deploy:restart', 'unicorn:reload' # app NOT preloaded
after 'deploy:restart', 'unicorn:restart' # app preloaded

# Asset pipeline
load 'deploy/assets'

after 'deploy:setup', 'deploy:set_privileges'
after 'deploy:setup', 'deploy:create_shared_socket_path'
after 'deploy:restart', 'deploy:cleanup'
after "deploy:update_code", 'deploy:secondary_symlink'

namespace :deploy do
  task :create_shared_socket_path, :roles => [:app, :web] do
    run "mkdir -p #{shared_path}/sockets"
  end

  task :set_privileges, :roles => [:app, :web] do
    try_sudo "chmod g+s #{deploy_to}"
  end

  task :secondary_symlink, :except => { :no_release => true }, :roles => [:app, :web] do
    run "rm -f #{release_path}/config/database.yml"
    run "ln -s #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  end
end
