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
  session[:client_num] ||= 0
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
  session[:client_num] += 1
  session[:clients] << {
    client_num: session[:client_num],
    client_first: params[:client_first].capitalize,
    client_last: params[:client_last].capitalize,
    client_info: []
  }
  redirect '/clients'
end

get '/clients/client_new' do
  erb :client_new
end

get '/clients/:client_num' do
  
  erb :client_info
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
