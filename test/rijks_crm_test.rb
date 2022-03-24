ENV["RACK_ENV"] = 'test'

require 'coveralls'
Coveralls.wear!

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
end