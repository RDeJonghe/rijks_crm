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

get '/' do
  redirect '/about'
end

get '/about' do
  erb :about
end

get '/clients' do
  erb :clients
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

