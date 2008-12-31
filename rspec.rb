plugin 'rspec',
  :git => 'git://github.com/dchelimsky/rspec.git'
plugin 'rspec-rails',
  :git => 'git://github.com/dchelimsky/rspec-rails.git'

generate "rspec"

# remove test dir
git :rm => '-r test'

git :add => "."
git :commit => "-a -m 'Added RSpec for testing'"
