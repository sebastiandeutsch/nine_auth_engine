namespace :nine_auth_engine do
  desc "Synchronize NineAuth migrations with the root application's"
  task :sync => :environment do
    require 'fileutils'
    
    # Migrations
    migrations = File.join(RAILS_ROOT, 'vendor', 'plugins', 'nine_auth_engine', 'db', 'migrate', '.')
    migrations_sync_target = File.join(RAILS_ROOT, 'db', 'migrate')

    # Copy DB migrations
    puts "Copying migrations to db/migrate"
    FileUtils.cp_r(migrations, migrations_sync_target)
  end
end