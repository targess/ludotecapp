source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
# Use PostgreSQL DB
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'jquery-ui-rails'

gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Bootstrap and font-simple-line-icons
gem 'bootstrap-sass', '~> 3.3.7'
# Font awesome icons
gem "font-awesome-rails"

# gem 'bgg' to parse BoardGameGeek API
gem 'bgg'

# Datetime picker
gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.43'

# Data confirm boostrap modal style
gem 'data-confirm-modal'

# kaminari pagination
gem 'kaminari'

# easy and unobtrusive way to use jQuery's autocomplete
gem 'rails-jquery-autocomplete'

# soft delete
gem "paranoia"

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem "faker"
# Faker DNI and NIE
gem "dni_faker"

gem 'devise'

gem "slim"

group :development, :test do
  # Set of gems to-do testing
  gem "rspec-rails"
  gem "factory_girl_rails"
  gem "guard-rspec"
  gem 'spring-commands-rspec'
  gem 'rails-controller-testing'

  gem 'timecop'

  gem 'pry-rails'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production do
  gem 'rails_12factor'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
