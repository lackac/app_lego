git :rm => "public/javascripts/*"

file 'public/javascripts/jquery.js',
  open('http://ajax.googleapis.com/ajax/libs/jquery/1.2/jquery.min.js').read
file 'public/javascripts/jquery.full.js',
  open('http://ajax.googleapis.com/ajax/libs/jquery/1.2/jquery.js').read
file 'public/javascripts/jquery-ui.js',
  open('http://ajax.googleapis.com/ajax/libs/jqueryui/1.5/jquery-ui.min.js').read
file 'public/javascripts/jquery-ui.full.js',
  open('http://ajax.googleapis.com/ajax/libs/jqueryui/1.5/jquery-ui.js').read
file 'public/javascripts/jquery.form.js',
  open('http://jqueryjs.googlecode.com/svn/trunk/plugins/form/jquery.form.js').read

file "public/javascripts/application.js", <<-JS
$(function() {
  // ...
});
JS

git :add => "."
git :commit => "-a -m 'Added jQuery with UI and form plugin'"
