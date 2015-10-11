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
  @posts = Post.all
  erb :index
end

get "/sign-in" do
  erb :sign_in_form
end

get "/sign-up" do
  erb :sign_up_form
end

post "/sign-up" do
  @user = User.create(user_name: params[:username], password: params[:password], fname: params[:fname], lname: params[:lname],email: params[:email])
    if @user.fname==""||@user.lname==""||@user.email==""||@user.password==""
         flash[:alert] = "Give it another whirl dumb nutz?"
         redirect '/sign-up'
	else
    #my_user = User.find(user_name: params[:username])
    #session[:user_id] = my_user.id
    #if my_user == session[:user_id] = @user.id
    #flash[:notice] = "Welcome new user...."
	#else
	#flash[:alert] = "There was a problem creating your account, try again dumb nutz"
	
     redirect "/sign-in"
    end
end

post "/sign-in" do
  @user = User.where(user_name: params[:username]).first

  if @user && @user.password == params[:password]
    session[:user_id] = @user.id
    flash[:notice] = "Get ready to Jatz...."
    redirect '/'
  else
    flash[:alert] = "Your not quite ready to Jam yet..Try agin!"
  	 redirect '/sign-in' 
    end
  end

  get '/sign-out' do
  session.clear
  redirect '/sign-in'
end

get '/posts' do
  erb :posts
  
end

post '/posts' do
  Post.create(subject: params[:subject], body: params[:body], user_id: session[:user_id])
  redirect to('/')
end

get "/users/:id" do
  @user = User.find(params [:id])
end
