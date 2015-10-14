require 'sinatra' 
require 'sinatra/activerecord'
require './models'
require 'sinatra/flash'


#set :database, "sqlite3:jamz.sqlite3"
#configure(:development){set :database, "sqlite3:jamz.sqlite3"}

set :database, "sqlite3:jamz.sqlite3"


enable :sessions

#get "/posts" do
  #if session[:user_id]
    #@user = User.find(session[:user_id])
  #end
  #@posts = Post.all
  #erb :posts
#end

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
    redirect '/posts/new'
  else
    flash[:alert] = "Your not quite ready to Jam yet..Try agin!"
  	 redirect '/sign-in' 
    end
  end

  get '/sign-out' do
  session.clear
  redirect '/sign-in'
end



get "/users/:id" do
  @user = User.find(params [:id])
end


# HTTP GET method and "/posts/new" action route
get "/posts/new" do
  # this will output whatever is within the new_post.erb template
  erb :new_post
end

post '/posts' do
  Post.create(subject: params[:subject], body: params[:body], user_id: session[:user_id])
  redirect '/posts'
end




# HTTP GET method and "/posts" action route
get "/posts" do
  # this loads all the created posts from the database
  #   and stores it within the @posts instance variable
  #   ONLY OF THE LOGGED IN USER
  @posts = Post.where(user_id: session[:user_id])

  # this will output whatever is within the posts.erb template
  erb :posts
end



# HTTP GET method and "/posts/followers" action route
get "/posts/followers" do
  # this loads all the created posts from the logged in user's
  #   followers
  # this block here puts all the posts into an array
  @posts = current_user.followers.inject([]) do |posts, follower|
    # this takes the current follower's posts and add them to the
    #   posts array we are building
    posts << follower.posts
  end

  # at this point the the posts are in the form of an array within an
  #   an array so we use the ruby array method (flatten) which makes
  #   it so that it is goes from say [[1,2],[5,6],[1,3]] to [1,2,3,5,6,1,3]
  #   http://ruby-doc.org/core-2.2.3/Array.html#method-i-flatten
  @posts.flatten!

  # this will output whatever is within the posts.erb template
  # notice how this also goes to the posts.erb template
  #   think DRY (Don't Repeat Yourself)
  erb :posts
end

# HTTP GET method and "/posts/all" action route
get "/posts/all" do
  # this loads all the created posts from the database
  #   and stores it within the @posts instance variable
  @posts = Post.all

  # this will output whatever is within the posts.erb template
  # notice how this also goes to the posts.erb template
  #   think DRY (Don't Repeat Yourself)
  erb :posts
end

# HTTP GET method and "/posts/followers" action route
get "/posts/followers" do
  # this loads all the created posts from the logged in user's
  #   followers
  # this block here puts all the posts into an array
  @posts = current_user.followers.inject([]) do |posts, follower|
    # this takes the current follower's posts and add them to the
    #   posts array we are building
    posts << follower.posts
  end

  # at this point the the posts are in the form of an array within an
  #   an array so we use the ruby array method (flatten) which makes
  #   it so that it is goes from say [[1,2],[5,6],[1,3]] to [1,2,3,5,6,1,3]
  #   http://ruby-doc.org/core-2.2.3/Array.html#method-i-flatten
  @posts.flatten!

  # this will output whatever is within the posts.erb template
  # notice how this also goes to the posts.erb template
  #   think DRY (Don't Repeat Yourself)
  erb :posts
end

# HTTP GET method and "/posts/all" action route
get "/posts/all" do
  # this loads all the created posts from the database
  #   and stores it within the @posts instance variable
  @posts = Post.all

  # this will output whatever is within the posts.erb template
  # notice how this also goes to the posts.erb template
  #   think DRY (Don't Repeat Yourself)
  erb :posts
end


# HTTP GET method and "/users/all" action route
get "/users/all" do
  # this loads all the created posts from the database
  #   and stores it within the @posts instance variable
  @users = User.all

  # this will output whatever is within the users.erb template
  erb :users  
end

# HTTP GET method and "/followees" action route
get "/followees" do
  # here we are grabbing all the users that the logged in user is following
  @users = current_user.followees

  # this will output whatever is within the users.erb template
  # notice how this also goes to the posts.erb template
  #   think DRY (Don't Repeat Yourself)
  erb :users
end

# HTTP GET method and "/followers" action route
get "/followers" do
  # here we are grabbing all the users that are following the logged in user 
  @users = current_user.followers

  # this will output whatever is within the users.erb template
  # notice how this also goes to the posts.erb template
  #   think DRY (Don't Repeat Yourself)
  erb :followers
end

# HTTP GET method and "/users/:user_id/follow" action route
get "/users/:followee_id/follow" do
  # here we are creating an association between the current user
  #   who is doing the following and the user you are tryng to follow
  Follow.create(follower_id: session[:user_id], followee_id: params[:followee_id])

  # this redirects to the get "/users/all" route
  # right now its hardcoded to go to this route but it would make
  #   more sense to have this redirect to the page that called it
  #   for our purposes now it will do but there is a more useful
  #   way to do this
  redirect "/users/all"
end

# HTTP GET method and "/users/:user_id/unfollow" action route
get "/users/:followee_id/unfollow" do
  # here we are finding the association where where the follower is
  #   is the logged in user and the followee is the user with
  #   a user_id equal to params[:followee_id]
  @follow = Follow.where(follower_id: session[:user_id], followee_id: params[:followee_id]).first
  @follow.destroy

  # this redirects to the get "/users/all" route
  # right now its hardcoded to go to this route but it would make
  #   more sense to have this redirect to the page that called it
  #   for our purposes now it will do but there is a more useful
  #   way to do this
  redirect "/users/all"
end





def current_user
  if session[:user_id]
    @current_user = User.find(session[:user_id])
  end
end
