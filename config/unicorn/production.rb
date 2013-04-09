# Based on http://ariejan.net/2011/09/14/lighting-fast-zero-downtime-deployments-with-git-capistrano-nginx-and-unicorn/

worker_processes 4
APP_PATH '/srv/apps/brandrpm/master/test.brandrpm.com'
SHARED_PATH "#{APP_PATH}/shared"
working_directory "#{APP_PATH}/current"

# This loads the application in the master process before forking
# worker processes
# Read more about it here:
# http://unicorn.bogomips.org/Unicorn/Configurator.html
preload_app true

timeout 30

# This is where we specify the socket.
# We will point the upstream Nginx module to this socket later on
listen "#{SHARED_PATH}/sockets/unicorn.socket", :backlog => 64

user 'nginx', 'www-data'

pid "#{SHARED_PATH}/pids/unicorn.pid"

# Set the path of the log files inside the log folder of the testapp
stderr_path "#{SHARED_PATH}/log/unicorn.stderr.log"
stdout_path "#{SHARED_PATH}/log/unicorn.stdout.log"

before_fork do |server, worker|
# This option works in together with preload_app true setting
# What is does is prevent the master process from holding
# the database connection
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill('QUIT', File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
# Here we are establishing the connection after forking worker
# processes
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
