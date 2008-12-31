gem 'jchris-couchrest', :lib => 'couchrest', :source => 'http://gems.github.com'

plugin 'basic_model',
  :git => 'git://github.com/topfunky/basic_model.git'

git :add => "."
git :commit => "-a -m 'Added CouchDB support (through CouchRest and BasicModel)'"
