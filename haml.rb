gem 'haml', :version => '>= 2.1'
gem 'chriseppstein-compass', :lib => 'compass', :version => '>= 0.3.4'

run "haml --rails ."
run "echo -e 'y\nn\n' | compass --rails -f blueprint"

git :add => "."
git :commit => "-a -m 'Added haml for views and compass for css'"
