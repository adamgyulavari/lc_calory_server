set :stage, :production
set :branch, "master"

set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"

server '139.162.149.200', user: 'deployer', roles: %w{app db web}, primary: true

set :deploy_to, "/home/#{fetch(:deploy_user)}/apps/#{fetch(:full_app_name)}"

set :rails_env, :production

set :unicorn_worker_count, 2

set :enable_ssl, false
