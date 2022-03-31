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

class RijksCrmTest < Minitest::Test
  include Rack::Test::Methods

  # This is needed for testing - check LS lesson

  def app
    Sinatra::Application
  end

  # setup will add one client and one interaction to the database and sign a user in. this can then be used for testing

  def setup
    post '/clients', client_first: "Joe", client_last: "Jones", email: "jj@gmail.com", phone: "333-444-5555", street: "123 Main St", city: "Springfield", state: "KS", postal: "45654"
    post '/interactions', date: "03/30/2022", full_name: "Joe Jones", type: "Email", comments: "Sent message"
    post '/admin/signin', username: "Ryan", password: "orange"
  end

  # this is added so a session can be accessed in testing. You'll see session[:key] in the tests accessing this

  def session
    last_request.env["rack.session"]
  end

  # tests that / redirects to /about

  def test_home_redirect
    get '/'
    assert_equal 302, last_response.status
  end

  # tests that the about page content

  def test_about_page
    get '/about'
    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']
    assert_includes last_response.body, "Rijks CRM is beta version of a customer relationship management tool."
  end

  # tests inventory page content

  def test_inventory_page
    get '/inventory'
    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']
    assert_includes last_response.body, "Artist Inventory"
    assert_includes last_response.body, "Jheronimus Bosch"
    assert_includes last_response.body, "Rembrandt van Rijn"
    assert_includes last_response.body, "Hendrick ter Brugghen"
    assert_includes last_response.body, "Vincent van Gogh"
  end

  # tests that the page for an artist has correct content - this just tests one artist

  def test_inventory_artist_page
    get '/inventory/bosch'
    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']
    assert_includes last_response.body, "Jheronimus Bosch"
    assert_includes last_response.body, "Heilige Christoffel"
    assert_includes last_response.body, "Leprozenbedelaar in de gedaante van de Duivel"
  end

  # tests that the work of art page has correct content - tests just one work of art

  def test_work_of_art_page
    get '/inventory/bosch/en-RP-P-1963-630'
    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']
    assert_includes last_response.body, "Jheronimus Bosch"
    assert_includes last_response.body, "H. Christoffel en de kluizenaar"
    assert_includes last_response.body, "1506 - 1578"
  end

  # tests that the client page content is correct. the client made in setup is tested to make sure they appear on the client list here

  def test_clients_page
    get '/clients'
    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']
    assert_includes last_response.body, "All Clients"
    assert_includes last_response.body, "Jones, Joe"
  end

  # tests that the content of admin page is correct with the user signed in from setup
  def test_admin_page
    get '/admin'
    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']
    assert_includes last_response.body, "Administration"
    assert_includes last_response.body, "Sign In"
    assert_includes last_response.body, "Signed in as Ryan"
    assert_includes last_response.body, "Sign Out"

  end

  # tests that the content of the interactions page is displaying correctly with the interaction from setup being displayed

  def test_interactions_page
    get '/interactions'
    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']
    assert_includes last_response.body, "Interactions"
    assert_includes last_response.body, "03/30/2022 - Email - Joe Jones"
  end

  # tests that the add new interaction page displays

  def test_interaction_new_page
    get '/interactions/interaction_new'
    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']
    assert_includes last_response.body, "Add New Interaction"
  end

  # tests that you can add a new interaction and that the new interaction appears on the list of interactions. careful here note how the form for interactions has "full_name" instead of "client_name" which is used for clients. Be aware while testing.

  def test_add_new_interaction
    post '/interactions', date: "03/31/2022", full_name: "Joe Jones", type: "Phone", comments: "Spoke with him"
    get '/interactions'
    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']
    assert_includes last_response.body, "03/31/2022 - Phone - Joe Jones"
  end

  # tests the content for adding a new client

  def test_client_new_page
    get '/clients/client_new'
    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']
    assert_includes last_response.body, "Add New Client"
  end

  # tests that the search page has correct content

  def test_search_page
    get '/search'
    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']
    assert_includes last_response.body, "Search Clients"
  end

  # tests the titles instance method

  def test_titles
    assert_equal true, Bosch.new.titles.any? { |title_obj| title_obj[:title] == "Heilige Christoffel" }
  end

  # tests the image instance method

  def test_image
    assert_equal "https://lh6.ggpht.com/d7mtmu4pqW0dT9B5ofX3aQldNoTsGZSB3w83ylyV5O3edcwLOf0pfksIJPUy1tvhSos-BLdj1TZZcqHcSAviCsjNya4=s0", Bosch.new.image("en-RP-P-1963-630")
  end

  # tests the title instance method

  def test_title
    assert_equal "H. Christoffel en de kluizenaar", Bosch.new.work_title("en-RP-P-1963-630")
  end

  # tests the produced instance method
  def test_produced
    assert_equal "1506 - 1578", Bosch.new.produced("en-RP-P-1963-630")
  end

  # tests signing in with bad credentials

  def test_signin_with_bad_credentials
    post "/admin/signin", username: "guest", password: "admin"
    assert_equal 422, last_response.status
    assert_includes last_response.body, "Invalid credentials"
  end

  # tests redirection after signing out

  def test_signout
    post "/admin/signin", username: "user", password: "orange"
    post "/admin/signout"
    
    get '/'
    assert_equal 302, last_response.status
  end

  # This test will return a string saying you can't create interactions without the client first created. Works correctly message shows. Need to delete the client that was created

  def test_post_interactions_without_created_client
    client_num = client_num = session[:clients][0][:client_num]

    get "/clients/#{client_num}/destroy"

    post '/interactions', id: "12345", date: "03/30/2022", client_full: "Joe Jones", type: "Email", comments: "Sent message"
    get '/interactions'
    assert_includes last_response.body, "Interactions need a client to be linked to. There are no clients."
  end

  # This test is similar to above test but it will first create a client. With an existing client it will then create an interaction successfully. This will test that the listing of interactions includes this new interaction (but this is not the page for the actual interaction details)

  def test_post_interactions_with_created_client
    get '/interactions'
    assert_includes last_response.body, "Joe Jones"
    assert_includes last_response.body, "03/30/2022"
    assert_includes last_response.body, "Email"
  end

  # SAME TEST AS ABOVE BUT WITH A SESSION, USES SET UP, CAN JUST USE THIS TEST

  def test_post_interactions_with_created_client
    get '/interactions'
    assert_equal "Joe Jones", session[:interactions][0][:client_full]
    assert_equal "03/30/2022", session[:interactions][0][:date]
    assert_equal "Email", session[:interactions][0][:type]
    assert_equal "Sent message", session[:interactions][0][:comments]
  end

  # This test is to test a created client. The client is created and the client page list is checked to make sure they appear on it with the format of first, last.

  def test_post_created_client
    post '/clients', client_num: "99999", client_first: "Joe", client_last: "Jones"
    get '/clients'
    assert_includes last_response.body, "Jones, Joe"
  end

  # same test as above but with a session. The client id is generated randomly, so here we are just testing the size of it.
  def test_post_created_client_with_session
    assert_equal 20, session[:clients][0][:client_num].size
    assert_equal "Joe", session[:clients][0][:client_first]
    assert_equal "Jones", session[:clients][0][:client_last]
  end

  # Testing the info page for a client, the client number is gotten from the session and put in the route. Test checks to see if the info that was entered in the set up is displayed on the page.

  def test_client_info_page
    client_num = session[:clients][0][:client_num]

    get "/clients/#{client_num}"

    assert_includes last_response.body, "Joe Jones"
    assert_includes last_response.body, "jj@gmail.com"
    assert_includes last_response.body, "333-444-5555"
    assert_includes last_response.body, "123 Main St"
    assert_includes last_response.body, "Springfield"
    assert_includes last_response.body, "KS"
    assert_includes last_response.body, "45654"
  end

  # testing the interaction page for a specific interaction to make sure it shows the info. Similar to the test above but to test the interaction page instead of the client page

  def test_interaction_info_page
    interaction_id = session[:interactions][0][:id]

    get "/interactions/#{interaction_id}"

    assert_includes last_response.body, "03/30/2022"
    assert_includes last_response.body, "Joe Jones"
    assert_includes last_response.body, "Email"
    assert_includes last_response.body, "Sent message"
  end

  # tests that an interaction has been deleted. the setup method will set up an interaction. the post method here will delete it. the assertion is checking that the size of the interactions array is 0 since the only interaction will have been deleted

  def test_delete_interaction
    interaction_id = session[:interactions][0][:id]

    post "/interactions/#{interaction_id}/destroy"

    assert_equal 0, session[:interactions].size
  end

  # tests that the sign in works from the setup

  def test_signin_working 
    assert_equal "Ryan", session[:username]
  end

  # testing when edits are submitted. In this case when the edit page it submit it posts back to this address. So we are testing the post here. Setup has a record ready that will be edited

  def test_posting_the_edits_to_client_record
    client_num = session[:clients][0][:client_num]

    post "/clients/#{client_num}", client_first: "Joseph", client_last: "Jonez", email: "mrjones@gmail.com", phone: "999-999-9999", street: "999 Bay Drive", city: "San Diego", state: "CA", postal: "98765"

    get "clients/#{client_num}"

    assert_includes last_response.body, "Joseph"
    assert_includes last_response.body, "Jonez"
    assert_includes last_response.body, "mrjones@gmail.com"
    assert_includes last_response.body, "999-999-9999"
    assert_includes last_response.body, "999 Bay Drive"
    assert_includes last_response.body, "San Diego"
    assert_includes last_response.body, "CA"
    assert_includes last_response.body, "98765"
  end
end


