require 'rubygems'
require 'cgi'

require "bundler"
Bundler.setup

require 'rack'
require 'sinatra'
require "sinatra/reloader" if development?
require 'json'
require 'geoip'
require 'rack/contrib/jsonp'
use Rack::JSONP

configure :production do
  require 'newrelic_rpm'
end

configure do
  GEOIP = GeoIP.new('GeoLiteCity.dat')
end

get '/' do
  'try something like /location.json?ip=134.226.83.50 to check a specific IP or /locateme.json to geocode your own IP'
end

get '/location.json' do
  callback = params.delete('callback')
  returnable = {:message => "you didn't supply an IP to geocode!"}
  returnable = GEOIP.city(params[:ip]).to_hash if params[:ip]
  json = returnable.to_json
  if callback
    content_type :js, :charset => "utf-8"
    response = "#{callback}(#{json})" 
  else
    content_type :json, :charset => "utf-8"
    response = json
  end
  response
end

get '/locateme.json' do
  content_type :json, :charset => "utf-8"
  returnable = {:message => "your IP could not be geocoded"}
  if geoip_result = GEOIP.city(request.ip)
    returnable = geoip_result.to_hash
  end
  returnable.to_json
end
