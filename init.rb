# Include hook code here
load_paths.each do |path|
  ActiveSupport::Dependencies.load_once_paths.delete(path)
end if config.environment == 'development'