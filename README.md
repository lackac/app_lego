# App LEGO

These are modularized Rails application templates. The templates can be used on their own but more powerful app generation is possible through the `app_lego.rb` template.

## Features

* modular structure
* uses git, every module makes a separate commit
* guiding questions or options through the LEGOS environment variable

# Usage

The simplest way to use the template is to just provide the URL of `app_lego.rb` to the rails app generator and answer the questions.

    $ rails -m http://github.com/lackac/app_lego/raw/master/app_lego.rb my_app

The options and modules can be passed in through the `LEGOS` environment variable. If this is set the generator won't ask whether it should use braid and which modules it should use.

Listing all the available options and modules:

    $ LEGOS="braid,basic,rspec,haml,jquery,auth,couchdb,locale,misc" rails -m http://github.com/lackac/app_lego/raw/master/app_lego.rb my_app

# Options

## Braid

App LEGO can use [Braid](http://github.com/evilchelu/braid/wikis) to manage vendor branches. If braid is selected all `plugin` calls will install through braid, but if it's not `plugin` calls will use the default `script/plugin` installer.

# Modules

The **basic** module initializes the Rails application in a git repository, removes unnecessary files and directories, sets up `.gitignore` files and freezes Edge Rails.

The **RSpec** module remove the `test` directory and installs the plugins necessary for RSpec. It also runs the rspec generator.

The **Haml** module initializes the app for [Haml](http://haml.hamptoncatlin.com/) and [Compass](http://github.com/chriseppstein/compass/wikis). Sass files for Compass are installed in `app/stylesheets` and it uses the Blueprint css library. Other modules take care of generating haml template files if haml was installed.

The **jQuery** module removes the default javascript files and installes jQuery, jQuery-UI and the jQuery Form plugin. The first two come with minified and full versions too.

The **Auth** module adds the AuthLogic gem and generates a UserSession model for it with an optional user model. The name of the user model and the user identifier can be given in the `USER_MODEL` and `USER_IDENT` environment variables.

The **CouchDB** module installs the [CouchRest](http://github.com/jchris/couchrest/tree/master) gem and the [BasicModel](http://github.com/topfunky/basic_model/tree/master) plugin.

The **locale** module will download localization files from Sven Fuchs' [rails-i18n](http://github.com/svenfuchs/rails-i18n/tree/master/rails/locale) repository. The generator will ask for the list of the localizations the user wants, but it can be given through the `LOCALES` environment variable too. The list is comma separated, and where no extension is given `.yml` is assumed. The first locale in the list will be used as the default locale. Example:

    $ LOCALES='hu,de,nl.rb' LEGOS='locale' rails -m http://github.com/lackac/app_lego/raw/master/app_lego.rb my_app

The locale module also checks for module specific localizations in `locales/` under the same path App LEGO was called from.
  
The **misc** module inserts miscellaneous files into the application. These include a basic `application_controller.rb`, some helpers, a basic layout with flashes taken care of and some initializers.

So far this is all. Feel free to fork the repository and send me pull requests if you find out something cool.

# Disclaimer

I borrowed some ideas from Jeremy McAnally's [rails-templates](http://github.com/jeremymcanally/rails-templates/tree/master) repository.

App LEGO is licensed under the MIT License.
