# config valid only for Capistrano 3.1
# lock '3.2.1'

set :application, 'clastic'
set :repo_url, 'git@github.com:Clastic/Clastic.git'
set :deploy_to, '/var/apps/clastic/clastic'

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :info

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{app/config/parameters.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 2


namespace :deploy do
  after :updating, :make_install do
    on roles(:app) do |host|
      within release_path do
        execute :chmod, '-R 777 app/logs app/cache'
        execute :setfacl, '-R -m u:"www-data":rwX -m u:`whoami`:rwX app/cache app/logs'
        execute :setfacl, '-dR -m u:"www-data":rwX -m u:`whoami`:rwX app/cache app/logs'
        if test "[ -d #{current_path.join('vendor')} ]"
          execute :cp, "-R", current_path.join('vendor'), release_path.join('vendor')
        end
        if test "[ -d #{current_path.join('node_modules')} ]"
          execute :cp, "-R", current_path.join('node_modules'), release_path.join('node_modules')
        end
        execute :make, "install"
      end
    end
  end
end
