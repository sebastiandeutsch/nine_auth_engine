namespace :nine_auth_engine do
  desc "Synchronize nine_auth migrations with the root application"
  task :sync => :environment do
    require 'fileutils'
        
    # Migrations
    vrame_migrations = File.join(RAILS_ROOT, 'vendor', 'plugins', 'nine_auth_engine', 'db', 'migrate', '.')
    migrations_sync_target = File.join(RAILS_ROOT, 'db', 'migrate')
    
    # Copy DB migrations
    puts "Copying migrations to db/migrate"
    FileUtils.cp_r(vrame_migrations, migrations_sync_target)
  end
end