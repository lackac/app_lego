# environment options
@lego_options = ENV['LEGOS'] ? ENV['LEGOS'].downcase.split(/[,\s]+/) : false

def use_lego?(lego, question)
  if @lego_options
    @lego_options.include?(lego)
  else
    yes?(question)
  end
end

# braid helpers
if use_lego?("braid", "Use braid for vendor management?")
  def braid(repo, dir, type=nil)
    run "braid add #{"-t #{type} " if type}#{repo} #{dir}"
  end

  def plugin(name, options)
    log "braid plugin", name

    if options[:git] || options[:svn]
      in_root do
        `braid add -p #{options[:svn] || options[:git]}`
      end
    else
      log "! no git or svn provided for #{name}. skipping..."
    end
  end
end

modules = [
  ["rspec",   "Use RSpec instead of test/unit?"],
  ["haml",    "Use haml for views and sass for css?"],
  ["jquery",  "Use jQuery instead of Prototype + Script.aculo.us?"],
  ["couchdb", "Use CouchDB?"],
  ["locale",  "Add specific localizations?"],
  ["misc",    "Add miscellaneous stuff (helpers, basic layout, flashes, initializers)?"],
]

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
  freeze!
end

log "initialized", "application structure"

if @lego_options or yes?("Do you want to play LEGO?")
  all_yes = @lego_options ? false : yes?("Install everything without question?")

  base_path = if template =~ %r{^(/|\w+://)}
    File.dirname(template)
  else
    log '', "You used the app generator with a relative template path."
    ask "Please enter the full path or URL where the modules are located:"
  end

  modules.each do |modul, question|
    if all_yes or use_lego?(modul, question)
      tmpl = "#{base_path}/#{modul}.rb"
      log "applying", "template: #{tmpl}"
      load_template(tmpl)
      log "applied", tmpl
    end
  end
end
