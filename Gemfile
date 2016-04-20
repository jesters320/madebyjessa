source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.1'

# Use sqlite3 as the database for Active Record
group :development, :test do
  gem 'sqlite3', '1.3.11'
end

gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'

# for transactional emails
# gem 'mandrill-api', '~> 1.0.53'
gem 'sendgrid-ruby'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use debugger
# gem 'debugger', group: [:development, :test]

group :production do
  gem 'pg', '0.15.1'
  gem 'rails_12factor', '0.0.2'
end
