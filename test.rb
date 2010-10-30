#require "colored"
#require "rails"
#require "haml"
#require "bundler"

#@path = "#{File.dirname(__FILE__)}/templates/"

#if yes?('Would you like to use HAML template system? (yes/no)')
#  puts "haml_flag = true"
#else
#  puts "haml_flag = false"
#end

def commit(message)
  git :add => "."
  git :commit => "-am '#{message}'"
end

git :init
commit "Generate structure"

run "rm -Rf .gitignore README public/index.html public/javascripts/* test public/images/rails.png"
commit "Delete unused files"
