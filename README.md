# Rails 3 template generator

## How to use

sqlite

rails new app_name -JT -m http://github.com/mauriciodeamorim/tempra/raw/master/setup.rb

mysql

rails new app_name -JT -d mysql -m http://github.com/mauriciodeamorim/tempra/raw/master/setup.rb

Test #{app_name}
apply "#{tdir}/test.rb"
