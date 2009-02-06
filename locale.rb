locales = (ENV['LOCALES'] || ask("Which locales do you want to use (separate with commas if more)?")).split(/[,\s]+/)

locales.each do |locale|
  locale += '.yml' unless locale =~ /\.(yml|rb)$/
  file "config/locales/#{locale}",
    open("http://github.com/svenfuchs/rails-i18n/raw/master/rails/locale/#{locale}").read
end

def uri_exists?(uri)
  uri = URI.parse(uri)
  Net::HTTP.start(uri.host, uri.port) do |http|
    http.head(uri.request_uri).is_a?(Net::HTTPSuccess)
  end
end

if @base_path
  log '', 'Trying to download module specific localizations...'
  @used_legos.each do |lego|
    locales.each do |locale|
      fn = "#{locale.split(".").first}.#{lego}.yml"
      path = "#{@base_path}/locales/#{fn}"
      if @base_path !~ /^https?:\/\// or uri_exists?(path)
        content = open(path).read rescue nil
        file "config/locales/#{fn}", content if content
      end
    end
  end
end

gsub_file "config/environment.rb",
  /(#\s*)?config.i18n.default_locale.*$/,
  "config.i18n.default_locale = '#{locales.first.gsub(/\.(yml|rb)$/, '')}'"

git :add => "."
git :commit => "-a -m 'Added #{locales.join(",")} localizations'"
