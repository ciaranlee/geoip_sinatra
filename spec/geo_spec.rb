# coding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe 'Geo' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
  before(:each) do
    @expected_json_result = {
      'request' => "87.192.100.212",
      'ip' => "87.192.100.212",
      'country_code2' => "IE",
      'country_code3' => "IRL",
      'country_name' => "Ireland",
      'continent_code' => "EU",
      'region_name' => "11",
      'city_name' => "Belmont",
      'postal_code' => "",
      'latitude' => 52.25999999999999,
      'longitude' => -9.708100000000002,
      'dma_code' => nil,
      'area_code' => nil,
      'timezone' => "Europe/Dublin"
    }
  end

  context "locateme.json" do
    it "returns a result for a real IP" do
      get '/locateme.json', nil, {'REMOTE_ADDR' => '87.192.100.212'}
      JSON.parse(last_response.body).should == @expected_json_result
    end

    it "returns a result for a bad IP" do
      get '/locateme.json'
      JSON.parse(last_response.body).should == {"message"=>"your IP could not be geocoded"}
    end
  end

  context '/location.json' do

    context "with good params" do
      before(:all) { get '/location.json?ip=87.192.100.212' }

      context "basics" do
        subject { last_response }
        its(:status) {should == 200}
        its(:content_type) {should == 'application/json;charset=utf-8'}
      end

      it "returns a good result" do
        JSON.parse(last_response.body).should == @expected_json_result
      end

    end

    context "with a callback" do
      before(:all) { get '/location.json?ip=87.192.100.212&callback=hey' }


      it "returns a single js function call, with the JSON content as an argument" do
        last_response.body.should match(/hey\((.+)\)/)
        last_response.body.match(/hey\((.+)\)/)
        JSON.parse($1).should == @expected_json_result
      end

    end

    context "with bad params" do
      before(:all) { get '/location.json' }

      context "basics" do
        subject { last_response }
        its(:status) {should == 200}
        its(:content_type) {should == 'application/json;charset=utf-8'}
      end

      context "response body" do
        subject { JSON.parse(last_response.body) }
        it { should == {"message"=>"you didn't supply an IP to geocode!"} }
      end
    end

  end
end