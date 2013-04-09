role :web, 'brand.linode'
role :app, 'brand.linode'
role :db,  'brand.linode', :primary => true

set :user, 'deployer'
