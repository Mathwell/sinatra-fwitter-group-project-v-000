class UserController<ApplicationController
  get '/signup' do
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
      @tweets=Tweet.all
      erb :'/tweets/tweets'
    else
      redirect to "/login"
    end
  end

  post '/signup' do
    if params[:username].empty? || params[:email].empty? || params[:password].empty?
      redirect to '/signup'
    else
      @user=User.new(:username => params[:username], :email => params[:email], :password => params[:password])
      @user.save
      session[:user_id]=@user.id
      redirect to '/tweets'
    end

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

get '/users/:slug' do
  @user=User.find_by_slug(params[:slug])
  erb :'/users/show'
end
end