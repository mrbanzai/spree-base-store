set :repository,  'git@github.com:mrbanzai/spree-base-store.git'
set :scm, 'git'
set :checkout, 'export'
set :application, 'www.brandrpmstore.com'

set :ssh_options, { :forward_agent => true }
default_run_options[:pty] = true
set :keep_releases, 5
set :group_writeable, false

set :stages, ['test', 'staging', 'production']
set :default_stage, 'production'
require 'capistrano/ext/multistage'

require 'bundler/capistrano'
set :bundle_flags, '--deployment --quiet --binstubs'

# Asset pipeline
load 'deploy/assets'

after 'deploy:setup', 'deploy:set_privileges'
after 'deploy:setup', 'deploy:create_shared_socket_path'
after 'deploy:restart', 'deploy:cleanup'

namespace :deploy do
  task :create_shared_socket_path, :roles => [:app, :web] do
    run "mkdir -p #{shared_path}/sockets"
  end

  task :set_privileges, :roles => [:app, :web] do
    try_sudo "chmod g+s #{deploy_to}"
  end
end
