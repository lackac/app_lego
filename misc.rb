# app files
file 'app/controllers/application_controller.rb', 
%q{class ApplicationController < ActionController::Base

  helper :all

  protect_from_forgery

  filter_parameter_logging "password" unless Rails.env.development?

end
}

file 'app/helpers/application_helper.rb', 
%q{module ApplicationHelper
  def page_title(title=nil)
    if title.nil?
      @page_title ||= ""
    else
      @page_title = title
    end
  end

  def body_class
    "#{controller.controller_name} #{controller.controller_name}-#{controller.action_name}"
  end
end
}

git :rm => 'config/locales/en.yml'
file 'config/locales/en.app.yml', <<-YAML
en:
  app_name: "APP_NAME"
YAML

if ENV['LOCALES']
  ENV['LOCALES'].split(",").map {|l| l.gsub(/\.(yml|rb)$/, '')}.uniq.each do |locale|
    file "config/locales/#{locale}.app.yml", <<-YAML
#{locale}:
  app_name: "APP_NAME"
    YAML
  end
end

if File.exists?('vendor/plugins/haml')

  file 'app/views/layouts/_flashes.html.haml', <<-HAML
#flash
  - flash.each do |key, value|
    %div{:id => "flash_\#{key}"}= value
  HAML

  file 'app/views/layouts/application.html.haml', <<-HAML
!!! XML
!!! Strict
%html{'xmlns' => 'http://www.w3.org/1999/xhtml', 'xml:lang' => 'en', 'lang' => 'en'}
  %head
    %meta{'http-equiv' => 'Content-Type', :content => 'text/html; charset=utf-8'}
    %title= "\#{page_title + ' - ' unless page_title.blank?}\#{t(:app_name)}"
    = stylesheet_link_tag 'screen.css', :media => 'screen, projection'
    = stylesheet_link_tag 'print.css', :media => 'print'
    /[if IE]
      = stylesheet_link_tag 'ie.css', :media => 'screen, projection'
  %body{:class => body_class}
    = render :partial => 'layouts/flashes'
    = yield
  HAML

else

  file 'app/views/layouts/_flashes.html.erb', <<-ERB
<div id="flash">
  <% flash.each do |key, value| -%>
    <div id="flash_<%= key %>"><%=h value %></div>
  <% end -%>
</div>
  ERB

  file 'app/views/layouts/application.html.erb', <<-ERB
<?xml version='1.0' encoding='utf-8' ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <meta http-equiv="Content-type" content="text/html; charset=utf-8" />
    <title><%= page_title + ' - ' unless page_title.blank? %><%=t :app_name %></title>
    <%= stylesheet_link_tag 'screen.css', :media => 'screen, projection' %>
    <%= stylesheet_link_tag 'print.css', :media => 'print' %>
    <!--[if IE]>
    <%= stylesheet_link_tag 'ie.css', :media => 'screen, projection' %>
    <![endif]-->
  </head>
  <body class="<%= body_class %>">
    <%= render :partial => 'layouts/flashes' -%>
    <%= yield %>
  </body>
</html>
  ERB

end


# initializers

initializer 'requires.rb', 
%q{Dir[Rails.root.join('lib', '*.rb')].each do |f|
  require f
end
}

git :add => "."
git :commit => "-a -m 'Added basic ApplicationController, helpers, layout, flashes, app localizations, initializers'"
