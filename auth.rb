# This installs Authlogic stuff at the moment but could support others too

gem 'authlogic'

generate 'session', 'user_session'

user_model = ENV['USER_MODEL'] || ask("What should be the name of the user model? (leave it empty to skip)")

unless user_model.blank?
  user_ident = ENV['USER_IDENT'] || ask("What is the identifier of a user? (e.g. login, email)")

  migration = "#{user_ident}:string crypted_password:string password_salt:string persistence_token:string single_access_token:string perishable_token:string login_count:integer last_request_at:datetime current_login_at:datetime last_login_at:datetime current_login_ip:string last_login_ip:string"

  if File.exists?('vendor/plugins/rspec')
    generate 'rspec_model', user_model, migration
  else
    generate 'model', user_model, migration
  end

  file "app/models/#{user_model.underscore}.rb", <<-RB
class #{user_model.classify} < ActiveRecord::Base
  acts_as_authentic # for options see documentation: Authlogic::ORMAdapters::ActiveRecordAdapter::ActsAsAuthentic::Config
end
  RB

  log "NOTE", "Don't forget to run 'rake db:migrate'."
end

git :add => "."
git :commit => "-a -m 'Added AuthLogic#{" and #{user_model} model" unless user_model.blank?}'"
