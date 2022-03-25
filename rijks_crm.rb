require "sinatra"
require "sinatra/reloader" if development?
require "tilt/erubis"


configure do
  enable :sessions
  set :session_secret, 'secret'
  set :erb, :escape_html => true
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

get '/inventory' do
  erb :inventory
end

get '/admin' do
  erb :admin
end

get '/interactions' do
  erb :interactions
end