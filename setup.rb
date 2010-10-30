def commit(message)
  git :add => "."
  git :commit => "-am '#{message}'"
end

git :init
commit "Generate structure"

run "rm -Rf .gitignore README public/index.html public/javascripts/* test public/images/rails.png"
commit "Delete unused files"

remove_file 'Gemfile'
create_file 'Gemfile', <<-GEMFILE
source 'http://rubygems.org'

gem 'devise'
gem 'hpricot' # need to generate devise:views
gem 'inherited_resources', '>=1.1.2'
gem 'rails', '3.0.1'
gem 'rails3-generators'
gem 'ruby_parser' # need to generate devise:views
gem 'thin'
gem 'will_paginate', '>=3.0.pre2'

group :development, :test do
  gem 'capybara', ">=0.3.6"
  gem 'cucumber', ">=0.6.3"
  gem 'cucumber-rails', ">=0.3.2"
  gem "factory_girl_rails"
  gem "pickle", ">=0.4.2"
  gem "rspec", ">=2.0.0"
  gem "rspec-rails", ">=2.0.0"
  gem "ruby-debug"
  gem 'spork', ">=0.8.4"  
end
GEMFILE
commit "Remove old and include new Gemfile"

#mongo = ask("Would you like to MongoDB? [Y,n]")
#if mongo.blank? || mongo.downcase == "y"
#  gem "mongoid_slug"
#  gem "mongo_ext"
#  gem "mongoid", "2.0.0.beta.19"
#  gem "bson_ext", "1.1"
#  gem "mongoid-rspec", :group => :test
#  commit "Include gems to MongoDB database"
#  application <<-GENERATORS
#    config.generators do |g|
#      g.orm :mongoid
#    end
#  GENERATORS  
#end

application <<-GENERATORS
  config.generators do |g|
      g.test_framework :rspec, :fixture => true
      g.fixture_replacement :factory_girl, :dir => "spec/support/factories"
    end
GENERATORS
commit "Config framework tests into application file"

rvm = ask("Would you like to configure gemset into RVM - ree1.8.7? [Y,n]")
if rvm.blank? || rvm.downcase == "y"
  file '.rvmrc', <<-RVMRC
  rvm gemset use #{app_name}
  RVMRC
  run "rvm gemset create #{app_name}"
  run "rvm gemset use #{app_name}"
  commit "Gemset #{app_name} with RVM ree1.8.7"
  run "rvm ree-1.8.7@#{app_name} gem install bundler"
  puts "=== Bundle install require few minutes and internet conection ==="
  run "rvm ree-1.8.7@#{app_name} -S bundle install"
  commit "Install gems with bundle"
else
  run "gem install bundler"
  run "bundle install"
  commit "Install gems with bundle"
end

generators = ask("Run generators? [Y,n] ")
if generators.blank? || generators.downcase == "y"
  run "rvm ree-1.8.7@#{app_name} -S rails g rspec:install"
  commit "Rspec files and configurations"
  run "rvm ree-1.8.7@#{app_name} -S rails g cucumber:install --capybara --rspec --spork"
  commit "Cucumber files and configurations"
  run "rvm ree-1.8.7@#{app_name} -S rails g pickle --path --email"
  commit "Pickle files and configurations"
  run "rvm ree-1.8.7@#{app_name} -S rails g devise:install"
  commit "Devise files and configurations"
  run "rvm ree-1.8.7@#{app_name} -S rails g devise User"
  commit "Create user with Devise"
  run "rvm ree-1.8.7@#{app_name} -S rails g devise Admin"
  commit "Create admin with Devise"
  run "rvm ree-1.8.7@#{app_name} -S rails g devise:views"
  commit "Create Devise views"  
#  run "rvm ree-1.8.7@#{app_name} -S rails g mongoid:config" if mongo.blank? || mongo.downcase == "y"
#  commit "MongoId config"
end

get "http://github.com/rails/jquery-ujs/raw/master/src/rails.js", "public/javascripts/rails.js"
get "http://code.jquery.com/jquery-1.4.2.min.js", "public/javascripts/jquery/jquery-1.4.2.min.js"
get "http://github.com/mauriciodeamorim/tempra/raw/master/gitignore" ,".gitignore" 
get "http://github.com/laguiar/rails3_template/raw/master/factory_girl.rb", "features/support/factory_girl.rb"
get "http://github.com/laguiar/rails3_template/raw/master/devise_steps.rb", "features/step_definitions/devise_steps.rb"
commit "Get public files"

# Getting Application Views

#Others templates
#http://github.com/npverni/rails3-rumble-template
#http://github.com/moscn/rails-3-template
#http://github.com/shawn/shawns-rails3-template (folders)

