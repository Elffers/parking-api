set :application, 'parking-api'
set :repo_url, 'git@github.com:Elffers/parking-api.git'
set :use_sudo, false

set :deploy_to, '/var/www/parking-api'

set :rake, 'bundle exec rake'

set :workers, { "save_request" => 1 }

# Uncomment this line if your workers need access to the Rails environment:
# set :resque_environment_task, true


# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# set :deploy_to, '/var/www/my_app'
# set :scm, :git

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end

namespace :deploy do
  task :precompile do
    on roles :web do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute 'bundle exec rake', "assets:precompile"
        end
      end
    end
  end

end

