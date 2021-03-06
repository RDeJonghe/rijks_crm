require "sinatra"
require "sinatra/reloader" if development?
require "tilt/erubis"
require "securerandom"
require "httparty"

configure do
  enable :sessions
  set :session_secret, 'secret'
  # rubocop:disable Style/HashSyntax
  set :erb, :escape_html => true
  # rubocop:enable Style/HashSyntax
end

ARTISTS = [
  { abrv_name: "bosch", full_name: "Jheronimus Bosch" },
  { abrv_name: "rembrandt", full_name: "Rembrandt van Rijn" },
  { abrv_name: "ter_brugghen", full_name: "Hendrick ter Brugghen" },
  { abrv_name: "van_gogh", full_name: "Vincent van Gogh"}
]

def find_current_client
  session[:clients].select do |client|
    client[:client_num] == @client_num
  end
  .first
end

def find_current_interaction
  session[:interactions].select do |interaction|
    interaction[:id] == @interaction_id
  end
  .first
end

def matching_clients(query)
  results = []

  return results if !query || query.empty?

  session[:clients].each do |client| 
    if client[:client_full].downcase =~ Regexp.new(query.downcase)
      results << { client_full: client[:client_full], client_num: client[:client_num] }
    end
  end

  results
end

def clients_full_name_interaction
  @all_clients.each_with_object([]) do |client, results|
    results << client[:client_full]
  end
end

class Bosch
  BOSCH_API_CALL = HTTParty.get('https://www.rijksmuseum.nl/api/en/collection?key=ME1aaDBz&involvedMaker=Jheronimus+Bosch&imgonly=True&p=0-9999&s=chronologic')

  BOSCH_ART_OBJECTS = JSON.parse(BOSCH_API_CALL.body)["artObjects"]

  def titles
    BOSCH_ART_OBJECTS.each_with_object([]) do |art_obj, results|
      results << { title: art_obj["title"], id: art_obj["id"] }
    end
  end

  def image(id)
    BOSCH_ART_OBJECTS.select do |art_obj|
      art_obj["id"] == id
    end
    .first["webImage"]["url"]
  end

  def work_title(id)
    BOSCH_ART_OBJECTS.select do |art_obj|
      art_obj["id"] == id
    end
    .first["title"]
  end

  def produced(id)
    BOSCH_ART_OBJECTS.select do |art_obj|
      art_obj["id"] == id
    end
    .first["longTitle"]
    .split(", ")
    .last
  end
end

class Rembrandt
  REMBRANDT_API_CALL = HTTParty.get('https://www.rijksmuseum.nl/api/en/collection?key=ME1aaDBz&involvedMaker=Rembrandt+van+Rijn&imgonly=True&p=0-9999&s=chronologic')

  REMBRANDT_ART_OBJECTS = JSON.parse(REMBRANDT_API_CALL.body)["artObjects"]

  def titles
    REMBRANDT_ART_OBJECTS.each_with_object([]) do |art_obj, results|
      results << { title: art_obj["title"], id: art_obj["id"] }
    end
  end

  def image(id)
    REMBRANDT_ART_OBJECTS.select do |art_obj|
      art_obj["id"] == id
    end
    .first["webImage"]["url"]
  end

  def work_title(id)
    REMBRANDT_ART_OBJECTS.select do |art_obj|
      art_obj["id"] == id
    end
    .first["title"]
  end

  def produced(id)
    REMBRANDT_ART_OBJECTS.select do |art_obj|
      art_obj["id"] == id
    end
    .first["longTitle"]
    .split(", ")
    .last
  end
end

class TerBrugghen
  TER_BRUGGHEN_API_CALL = HTTParty.get('https://www.rijksmuseum.nl/api/en/collection?key=ME1aaDBz&involvedMaker=Rembrandt+van+Rijn&imgonly=True&p=0-9999&s=chronologic')

  TER_BRUGGHEN_ART_OBJECTS = JSON.parse(TER_BRUGGHEN_API_CALL.body)["artObjects"]

  def titles
    TER_BRUGGHEN_ART_OBJECTS.each_with_object([]) do |art_obj, results|
      results << { title: art_obj["title"], id: art_obj["id"] }
    end
  end

  def image(id)
    TER_BRUGGHEN_ART_OBJECTS.select do |art_obj|
      art_obj["id"] == id
    end
    .first["webImage"]["url"]
  end

  def work_title(id)
    TER_BRUGGHEN_ART_OBJECTS.select do |art_obj|
      art_obj["id"] == id
    end
    .first["title"]
  end

  def produced(id)
    TER_BRUGGHEN_ART_OBJECTS.select do |art_obj|
      art_obj["id"] == id
    end
    .first["longTitle"]
    .split(", ")
    .last
  end
end

class VanGogh
  VAN_GOGH_API_CALL = HTTParty.get('https://www.rijksmuseum.nl/api/en/collection?key=ME1aaDBz&involvedMaker=Vincent+van+Gogh&imgonly=True&p=0-9999&s=chronologic')

  VAN_GOGH_ART_OBJECTS = JSON.parse(VAN_GOGH_API_CALL.body)["artObjects"]

  def titles
    VAN_GOGH_ART_OBJECTS.each_with_object([]) do |art_obj, results|
      results << { title: art_obj["title"], id: art_obj["id"] }
    end
  end

  def image(id)
    VAN_GOGH_ART_OBJECTS.select do |art_obj|
      art_obj["id"] == id
    end
    .first["webImage"]["url"]
  end

  def work_title(id)
    VAN_GOGH_ART_OBJECTS.select do |art_obj|
      art_obj["id"] == id
    end
    .first["title"]
  end

  def produced(id)
    VAN_GOGH_ART_OBJECTS.select do |art_obj|
      art_obj["id"] == id
    end
    .first["longTitle"]
    .split(", ")
    .last
  end
end

helpers do
  def clients?
    @clients.any?
  end

  def interactions?
    @interactions.any?
  end

  def email?
    @current_client[:email].size > 0
  end

  def phone?
    @current_client[:phone].size > 0
  end

  def address?
    (@current_client[:address][:street].size > 0) &&
    (@current_client[:address][:city].size > 0) &&
    (@current_client[:address][:state].size > 0) &&
    (@current_client[:address][:postal].size > 0)
  end

  def last_name_comma_first_name(client)
    "#{client[:client_last]}, #{client[:client_first]}"
  end

  def interaction_date_client_type(interaction)
    "#{interaction[:date]} - #{interaction[:type]} - #{interaction[:client_full]}"
  end

  def artist_full_name
    ARTISTS.select do |artist|
      artist[:abrv_name] == @artist_abrv
    end
    .first[:full_name]
  end
end

before do
  session[:clients] ||= []
  session[:interactions] ||= []
end

get '/' do
  redirect '/about'
end

get '/about' do
  erb :about
end

get '/clients' do
  @clients = session[:clients].sort_by { |client| [client[:client_last], client[:client_first]] }

  erb :clients
end

post '/clients' do
  session[:clients] << {
    client_num: SecureRandom.hex(10),
    client_first: params[:client_first].capitalize.strip,
    client_last: params[:client_last].capitalize.strip,
    client_full: "#{params[:client_first].capitalize.strip} #{params[:client_last].capitalize.strip}",
    email: params[:email],
    phone: params[:phone],
    address: { 
      street: params[:street],
      city: params[:city],
      state: params[:state],
      postal: params[:postal]
    }
  }
  redirect '/clients'
end

get '/clients/client_new' do
  erb :client_new
end

get '/clients/:client_num' do
  @all = session[:clients]
  @client_num = params[:client_num]
  @current_client = find_current_client
  
  erb :client_info
end

get '/clients/:client_num/edit' do
  @client_num = params[:client_num]
  @current_client = find_current_client

  erb :client_edit
end

post '/clients/:client_num' do
  @client_num = params[:client_num]
  @current_client = find_current_client

  @current_client[:client_first] = params[:client_first]
  @current_client[:client_last] = params[:client_last]
  @current_client[:email] = params[:email]
  @current_client[:phone] = params[:phone]
  @current_client[:address][:street] = params[:street]
  @current_client[:address][:city] = params[:city]
  @current_client[:address][:state] = params[:state]
  @current_client[:address][:postal] = params[:postal]

  redirect "/clients/#{@client_num}"
end

get '/interactions' do
  @clients = session[:clients].sort_by { |client| [client[:client_last], client[:client_first]] }
  @interactions = session[:interactions].sort_by { |interaction| interaction[:date] }

  erb :interactions
end

get '/interactions/interaction_new' do
  @all_clients = session[:clients]
  @all_clients_full_names = clients_full_name_interaction

  erb :interaction_new
end

post '/interactions' do
  session[:interactions] << {
    id: SecureRandom.hex(10),
    date: params[:date],
    client_full: params[:full_name],
    type: params[:type],
    comments: params[:comments]
  }
  redirect '/interactions'
end

get '/interactions/:interaction_id' do
  @interaction_id = params[:interaction_id]
  @current_interaction = find_current_interaction

  erb :interaction_id
end

post '/interactions/:interaction_id/destroy' do
  session[:interactions].reject! do |interaction|
    interaction[:id] == params[:interaction_id]
  end

  redirect '/interactions'
end

get '/inventory' do
  erb :inventory
end

get '/inventory/:artist_abrv' do
  @artist_abrv = params[:artist_abrv]

  if @artist_abrv == "bosch"
    @titles_info = Bosch.new.titles
  elsif @artist_abrv == "rembrandt"
    @titles_info = Rembrandt.new.titles
  elsif @artist_abrv == "ter_brugghen"
    @titles_info = TerBrugghen.new.titles
  elsif @artist_abrv == "van_gogh"
    @titles_info = VanGogh.new.titles
  end

  erb :works
end

get '/inventory/:artist_abrv/:work_id' do
  @artist_abrv = params[:artist_abrv]
  work_id = params[:work_id]

  if @artist_abrv == "bosch"
    artist_obj = Bosch.new
  elsif @artist_abrv == "rembrandt"
    artist_obj = Rembrandt.new
  elsif @artist_abrv == "ter_brugghen"
    artist_obj = TerBrugghen.new
  elsif @artist_abrv == "van_gogh"
    artist_obj = VanGogh.new
  end

  @title = artist_obj.work_title(work_id)
  @produced = artist_obj.produced(work_id)
  @image = artist_obj.image(work_id)

  erb :work_id
end

get '/search' do
  @results = matching_clients(params[:query])

  erb :search
end

get '/admin' do
  @clients = session[:clients].sort_by { |client| [client[:client_last], client[:client_first]] }

  erb :admin
end

get '/admin/signin' do
  erb :signin
end

post '/admin/signin' do
  if (params[:username].size >= 1) && (params[:password].size >= 1)
    session[:username] = params[:username]
    session[:message] = "Welcome!"
    redirect "/admin"
  else
    session[:message] = "Invalid credentials"
    status 422
    erb :signin
  end
end

post '/admin/signout' do
  session.delete(:username)
  session[:message] = "You have been signed out."
  redirect "/admin"
end

get '/clients/:client_num/destroy' do
  session[:clients].reject! do |client|
    client[:client_num] == params[:client_num]
  end

  redirect '/admin'
end