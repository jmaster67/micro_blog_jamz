
get "/" do
if session[:user_id]
  @user = User.find(session[:user_id])
end
@posts = Post.all
erb :index
end

get '/sign-out' do
 session.clear
 redirect '/sign-in'
 end