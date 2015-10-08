require 'sinatra' 
require 'sinatra/activerecord'
require './models'
require 'sinatra/flash'

set :database, "sqlite3:jamz.sqlite3"

enable :sessions

get "/" do
  if session[:user_id]
    @user = User.find(session[:user_id])
  end

  erb :index
end

get "/sign-in" do
  erb :sign_in_form
end

post "/sign-in" do
  @user = User.where(user_name: params[:username]).first

  if @user && @user.password == params[:password]
    session[:user_id] = @user.id
    flash[:notice] = "Get ready to follow your Jamz...."
  else
    flash[:alert] = "Your not quite ready to Jam yet....."
  end

  redirect "/"
end

get "/sign-out" do
  if session[:user_id]
    @user = User.find(session[:user_id])
    session[:user_id] = nil
    flash[:notice] = "You have been signed out of the Jamz..."
  else
    flash[:alert] = "You must first Log into Jamz...."
  end

  redirect "/"
end

get "/sign-out" do
  if session[:user_id]
    @user = User.find(session[:user_id])
    session[:user_id] = nil
    flash[:notice] = "You have been signed out of the Matrix..."
  else
    flash[:alert] = "You must first choose the red pill"
  end

  redirect "/"
end