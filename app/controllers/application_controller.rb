require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "fwitter_secret"
  end

  get '/' do
    erb :index
  end

  get '/signup' do
    #binding.pry
    if logged_in?
      redirect to '/tweets'
    else
      erb :'users/create_user'
    end
  end

  get '/login' do
    if logged_in?
      redirect to '/tweets'
    else
      erb :'users/login'
    end
  end


  get '/tweets' do
    if logged_in?
      #@username=current_user.username
      @tweets=Tweet.all
      erb :'/tweets/tweets'
    else
      redirect to "/login"
    end
  end

  post '/signup' do
    puts params
    #binding.pry
    if params[:username].empty? || params[:email].empty? || params[:password].empty?
      redirect to '/signup'
    else
      @user=User.new(:username => params[:username], :email => params[:email], :password => params[:password])
      @user.save
      session[:user_id]=@user.id
      redirect to '/tweets'
    end
    #binding.pry
  end

  post '/login' do
    user = User.find_by(:username => params[:username])
		if user && user.authenticate(params[:password])
			 session[:user_id] = user.id
			 redirect "/tweets"
	 else
			 redirect "/signup"
	 end
  end

  get '/logout' do
  if session[:user_id] != nil
    session.destroy
    redirect to '/login'
  else
    redirect to '/tweets'
  end
end



get 'tweets/new' do
  erb :'/tweets/create_tweet'
end

get 'tweet/:id' do
  if logged_in?
     @tweet = Tweet.find_by_id(params[:id])
     erb :'tweets/show_tweet'
   else
     redirect to '/login'
   end
end

get 'tweet/:id/delete' do

end


  helpers do
		def logged_in?
			!!session[:user_id]
		end

		def current_user
			User.find(session[:user_id])
		end
	end

end
