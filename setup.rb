# Delete unused files
run "rm -Rf .gitignore README public/index.html public/javascripts/* test public/images/rails.png"

# Gemfile generate
remove_file 'Gemfile'
create_file 'Gemfile', <<-GEMFILE
source 'http://rubygems.org'

gem 'rails', '3.0.1'
gem 'rails3-generators'
gem 'inherited_resources', '>=1.1.2'
gem 'will_paginate', '>=3.0.pre2'
gem 'devise'
gem 'thin'

group :development, :test do
gem 'cucumber', ">=0.6.3"
gem 'cucumber-rails', ">=0.3.2"
gem 'capybara', ">=0.3.6"
gem 'database_cleaner', ">=0.5.0"
gem 'spork', ">=0.8.4"
gem "pickle", ">=0.4.2"
gem "factory_girl_rails"
gem "rspec-rails", :git => "git://github.com/rspec/rspec-rails.git"
gem "rspec", :git => "git://github.com/rspec/rspec.git"
gem "rspec-core", :git => "git://github.com/rspec/rspec-core.git"
gem "rspec-expectations", :git => "git://github.com/rspec/rspec-expectations.git"
gem "rspec-mocks", :git => "git://github.com/rspec/rspec-mocks.git"
gem "ruby-debugger"
end

GEMFILE

# Application Generators Config
application <<-GENERATORS
config.generators do |g|
g.test_framework :rspec, :fixture => true
g.fixture_replacement :factory_girl, :dir => "spec/support/factories"
end
GENERATORS

rvm = ask("Do you want configure RVM?[Y,n] ")

def rvm_setup 
# RVM
puts 'RVM configuration'
file '.rvmrc', <<-RVMRC
rvm gemset use #{app_name}
RVMRC

current_ruby = /^(.*):/.match(%x{rvm info})[1]
run "rvm gemset create #{app_name}"
run "rvm gemset use #{app_name}"
#run "rvm ree-1.8.7@#{app_name} gem install bundler"
#run "rvm ree-1.8.7@#{app_name} -S bundle install"
puts '=====', 'RVM done!', '====='
end

rvm_setup if rvm.blank? || rvm.downcase == "y"

run "gem install bundler"
run "bundle install"


# Run the generators
#run "rvm ree-1.8.7@#{app_name} -S rails g rspec:install"
generate "rspec:install"
generate "cucumber:install --capybara --rspec --spork"
generate "pickle --path --email"
generate "friendly_id"
generate "formtastic:install"
generate "devise:install"
generate "devise User"
generate "devise Admin"


# Getting Public Files
#get 'http://github.com/mauriciodeamorim/tempra', ''
get "http://github.com/rails/jquery-ujs/raw/master/src/rails.js", "public/javascripts/rails.js"
get "http://code.jquery.com/jquery-1.4.2.min.js", "public/javascripts/jquery/jquery-1.4.2.min.js"
get "http://github.com/mauriciodeamorim/tempra/raw/master/gitignore" ,".gitignore" 

# Getting Application Views

puts '=====', 'Git repository', '====='
git :init
git :add => '.'
git :commit => '-am "Initial commit"'
 
puts 'DONE!'

