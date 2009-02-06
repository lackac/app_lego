locales = (ENV['LOCALES'] || ask("Which locales do you want to use (separate with commas if more)?")).split(/[,\s]+/)

locales.each do |locale|
  locale += '.yml' unless locale =~ /\.(yml|rb)$/
  file "config/locales/#{locale}",
    open("http://github.com/svenfuchs/rails-i18n/raw/master/rails/locale/#{locale}").read
end

if @base_path
  log '', 'Trying to download module specific localizations...'
  @used_legos.each do |lego|
    locales.each do |locale|
      fn = "#{locale.split(".").first}.#{lego}.yml"
      content = open("#{@base_path}/locales/#{fn}").read rescue nil
      file "config/locales/#{fn}", content if content
    end
  end
end

gsub_file "config/environment.rb",
  /(#\s*)?config.i18n.default_locale.*$/,
  "config.i18n.default_locale = '#{locales.first.gsub(/\.(yml|rb)$/, '')}'"

git :add => "."
git :commit => "-a -m 'Added #{locales.join(",")} localizations'"
