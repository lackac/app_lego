# remove tmp dirs
run "rmdir tmp/{pids,sessions,sockets,cache}"

# remove unnecessary stuff
run "rm README log/*.log public/index.html public/images/rails.png"

# keep empty dirs
run("find . \\( -type d -empty \\) -and \\( -not -regex ./\\.git.* \\) -exec touch {}/.gitignore \\;")

# init git repo
git :init

# basic .gitignore file
file '.gitignore',
%q{log/*.log
log/*.pid
db/*.db
db/*.sqlite3
db/schema.rb
tmp/**/*
.DS_Store
doc/api
doc/app
config/database.yml
autotest_result.html
coverage
public/javascripts/*_[0-9]*.js
public/stylesheets/*_[0-9]*.css
public/attachments
}

# copy sample database config
run "cp config/database.yml config/database.yml.sample"

# commit changes
git :add => "."
git :commit => "-a -m 'Setting up a new rails app. Copy config/database.yml.sample to config/database.yml and customize.'"

# freeze edge rails
if respond_to?(:braid)
  braid "git://github.com/rails/rails.git", "vendor/rails"
else
  # Guess full Rails path
  rails_path = Pathname.new($LOAD_PATH.find {|p| p =~ /railties/}.gsub(%r{/railties/.*}, '')).realpath
  run "cp -r '#{rails_path}' vendor/rails"
  run "rm -rf vendor/rails/.git"
end

log "initialized", "application structure"
