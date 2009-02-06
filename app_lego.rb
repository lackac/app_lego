# environment options
@lego_options = ENV['LEGOS'] ? ENV['LEGOS'].downcase.split(/[,\s]+/) : false
@used_legos = []

def use_lego?(lego, question)
  use = if @lego_options
    @lego_options.include?(lego)
  else
    yes?(question)
  end
  @used_legos << lego if use
  use
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
  ["basic",   "Do basic setup? (only exclude this if you already have a Rails app skeleton with Rails 2.3+ frozen, or as a gem)"],
  ["rspec",   "Use RSpec instead of test/unit?"],
  ["haml",    "Use haml for views and sass for css?"],
  ["jquery",  "Use jQuery instead of Prototype + Script.aculo.us?"],
  ["auth",    "Add authentication module?"],
  ["couchdb", "Use CouchDB?"],
  ["locale",  "Add specific localizations?"],
  ["misc",    "Add miscellaneous stuff (helpers, basic layout, flashes, initializers)?"],
]

if @lego_options or yes?("Do you want to play LEGO?")
  all_yes = @lego_options ? false : yes?("Install everything without question?")

  @base_path = if template =~ %r{^(/|\w+://)}
    File.dirname(template)
  else
    log '', "You used the app generator with a relative template path."
    ask "Please enter the full path or URL where the modules are located:"
  end

  modules.each do |modul, question|
    if all_yes or use_lego?(modul, question)
      tmpl = "#{@base_path}/#{modul}.rb"
      log "applying", "template: #{tmpl}"
      load_template(tmpl)
      log "applied", tmpl
    end
  end
end
