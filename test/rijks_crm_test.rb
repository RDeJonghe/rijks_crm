ENV["RACK_ENV"] = 'test'

if ENV['RACK_ENV'] == 'test'
  require 'simplecov'
  SimpleCov.start
  puts "required simplecov in test environment"
end

require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!

require 'rack/test'

require_relative '../rijks_crm'

# Maybe do a set up of an environment with a client, an interaction, etc.

class RijksCrmTest < Minitest::Test
  include Rack::Test::Methods

  # This is needed for testing - check LS lesson

  def app
    Sinatra::Application
  end

  def test_home_redirect
    skip
    get '/'
    assert_equal 302, last_response.status
  end

  def test_about_page
    skip
    get '/about'
    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']
    assert_includes last_response.body, "About the Rijks CRM Project"
  end

  def test_inventory_page
    skip
    get '/inventory'
    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']
    assert_includes last_response.body, "Artist Inventory"
  end

  def test_inventory_artist_page
    skip
    get '/inventory/bosch'
    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']
    assert_includes last_response.body, "Jheronimus Bosch"
  end

  def test_work_of_art_page
    skip
    get '/inventory/bosch/en-RP-P-1963-630'
    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']
    assert_includes last_response.body, "Jheronimus Bosch"
    assert_includes last_response.body, "H. Christoffel en de kluizenaar"
    assert_includes last_response.body, "1506 - 1578"
  end

  def test_clients_page
    skip
    get '/clients'
    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']
    assert_includes last_response.body, "All Clients"
  end

  def test_admin_page
    skip
    get '/admin'
    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']
    assert_includes last_response.body, "Administration features coming soon..."
  end

  def test_interactions_page
    skip
    get '/interactions'
    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']
    assert_includes last_response.body, "Interactions"
  end

  def test_interaction_new_page
    skip
    get '/interactions/interaction_new'
    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']
    assert_includes last_response.body, "Add New Interaction"
  end

  def test_client_new_page
    skip
    get '/clients/client_new'
    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']
    assert_includes last_response.body, "Add New Client"
  end

  def test_search_page
    skip
    get '/search'
    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']
    assert_includes last_response.body, "Search Clients"
  end

  # TESTING OF OBJECTS/CLASSES/METHODS

  def test_titles
    skip
    assert_equal true, Bosch.new.titles.any? { |title_obj| title_obj[:title] == "Heilige Christoffel" }
  end

  def test_image
    skip
    assert_equal "https://lh6.ggpht.com/d7mtmu4pqW0dT9B5ofX3aQldNoTsGZSB3w83ylyV5O3edcwLOf0pfksIJPUy1tvhSos-BLdj1TZZcqHcSAviCsjNya4=s0", Bosch.new.image("en-RP-P-1963-630")
  end

  def test_title
    skip
    assert_equal "H. Christoffel en de kluizenaar", Bosch.new.work_title("en-RP-P-1963-630")
  end

  def test_produced
    skip
    assert_equal "1506 - 1578", Bosch.new.produced("en-RP-P-1963-630")
  end

  # TESTING SIGN IN

  def test_signin_with_bad_credentials
    skip
    post "/admin/signin", username: "guest", password: "admin"
    assert_equal 422, last_response.status
    assert_includes last_response.body, "Invalid credentials"
  end

  # TESTS REDIRECTION AFTER SIGNING OUT

  def test_signout
    skip
    post "/admin/signin", username: "user", password: "orange"

    post "/admin/signout"
    
    get '/'
    assert_equal 302, last_response.status
  end

  # TESTS POST ROUTE

  # This test will return a string saying you can't create interactions without the client first created. Works correctly message shows.

  def test_post_interactions_without_created_client
    skip
    post '/interactions', id: "12345", date: "03/30/2022", client_full: "Joe Jones", type: "Email", comments: "Sent message"
    get '/interactions'
    assert_includes last_response.body, "Interactions need a client to be linked to. There are no clients."
  end

  # This test is similar to above test but it will first create a client. With an existing client it will then create an interaction successfully. This will test that the listing of interactions includes this new interaction (but this is not the page for the actual interaction details)

  def test_post_interactions_with_created_client
    skip
    post '/clients', client_num: "99999", client_first: "Joe", client_last: "Jones"
    post '/interactions', date: "03/30/2022", full_name: "Joe Jones", type: "Email", comments: "Sent message"
    get '/interactions'
    assert_includes last_response.body, "Joe Jones"
    assert_includes last_response.body, "03/30/2022"
    assert_includes last_response.body, "Email"
  end

  # This test is to test a created client. The client is created and the client page list is checked to make sure they appear on it with the format of first, last.

  def test_post_created_client
    skip
    post '/clients', client_num: "99999", client_first: "Joe", client_last: "Jones"
    get '/clients'
    assert_includes last_response.body, "Jones, Joe"
  end
end





