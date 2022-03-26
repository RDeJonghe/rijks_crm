require "sinatra"
require "sinatra/reloader" if development?
require "tilt/erubis"

configure do
  enable :sessions
  set :session_secret, 'secret'
  # rubocop:disable Style/HashSyntax
  set :erb, :escape_html => true
  # rubocop:enable Style/HashSyntax
end

helpers do
  def clients?
    @clients.any?
  end

  def last_name_comma_first_name(client)
    "#{client[:client_last]}, #{client[:client_first]}"
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
  @clients = session[:clients]

  # @params_info = params

  erb :clients
end

post '/clients' do
  session[:clients] << { client_first: params[:client_first], client_last: params[:client_last], client_info: [] }
  redirect '/clients'
end

get '/clients/client_new' do
  erb :client_new
end

get '/interactions' do
  erb :interactions
end

get '/interactions/interaction_new' do
  erb :interaction_new
end
get '/inventory' do
  erb :inventory
end

get '/admin' do
  erb :admin
end

