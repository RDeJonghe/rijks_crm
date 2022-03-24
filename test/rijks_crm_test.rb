ENV["RACK_ENV"] = 'test'

# require 'coveralls'
# Coveralls.wear!

require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!

require 'rack/test'

require_relative '../rijks_crm.rb'


class RijksCrmTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_home_redirect
    get '/'
    assert_equal 302, last_response.status
  end

  def test_about_page
    get '/about'
    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']
    assert_includes last_response.body, "About the Rijks CRM Project!"
  end

  def test_inventory_page
    get '/inventory'
    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']
    assert_includes last_response.body, "Artist Inventory"
  end
end