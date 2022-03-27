require "sinatra"
require "sinatra/reloader" if development?
require "tilt/erubis"
require "securerandom"

configure do
  enable :sessions
  set :session_secret, 'secret'
  # rubocop:disable Style/HashSyntax
  set :erb, :escape_html => true
  # rubocop:enable Style/HashSyntax
end

def find_current_client
  session[:clients].select do |client|
    client[:client_num] == @client_num
  end
  .first
end

helpers do
  def clients?
    @clients.any?
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

  def notes?
    @current_client[:notes].size > 0
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
  @clients = session[:clients].sort_by { |client| [client[:client_last], client[:client_first]] }

  erb :clients
end

post '/clients' do
  session[:clients] << {
    client_num: SecureRandom.hex(10),
    client_first: params[:client_first].capitalize.strip,
    client_last: params[:client_last].capitalize.strip,
    email: params[:email],
    phone: params[:phone],
    address: { 
      street: params[:street],
      city: params[:city],
      state: params[:state],
      postal: params[:postal]
    },
    notes: ""
  }
  redirect '/clients'
end

get '/clients/client_new' do
  erb :client_new
end

get '/clients/:client_num' do
  @client_num = params[:client_num]
  @current_client = find_current_client
  
  erb :client_info
end

get '/clients/:client_num/edit' do
  @client_num = params[:client_num]
  @current_client = find_current_client

  erb :client_edit
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
