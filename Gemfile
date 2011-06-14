source 'http://rubygems.org'

gem "thin"
gem "rack"
gem "sinatra"
gem "json"
gem "geoip"

group :production do
  gem "newrelic_rpm"
end

group :development do
  gem "sinatra-reloader"
  gem "heroku"
end

group :test do
  gem "rack-test"
  gem "rspec"
end