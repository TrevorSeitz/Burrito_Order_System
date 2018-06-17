require 'pry'
class UserController < ApplicationController

  get "/users" do
    @users = User.all
    redirect "/users/index"
  end

  get "/users/new" do
    # # sign up a new user
    if is_logged_in?
      # if the user is already logged in - don't allow them to see the "new user" page
      # instead, redirect to their store's index page
      redirect "/users/index"
    else
      erb :"/users/new"
    end
  end

  get "/users/index" do
    @user = User.find_by_id(session[:user_id])
    # check to ensure user has a store attached
    if @user.store_id == nil
      # if not - go to store input form
      redirect "/stores/new"
    else
      # go to users main page
      erb :"/users/index"
    end
  end

  get "/errors/users/new" do
    #  go to user registration error page
    erb :"/errors/users/new"
  end

  get "/errors/users/existing_user" do
    #go to exsisting user error page
    erb :"/errors/users/existing_user"
  end

  get "/login" do
    # user login page
    if is_logged_in?
      # if the user is already logged in - don't allow them to see the "login" page
      # instead, redirect to their store's index page
      redirect "/users/index"
    else
      # if user is not already logged in - log them in
      redirect "/"
    end
  end

  get "/users/admin" do
    @user = User.find_by_id(session[:user_id])
    # check to ensure user is an admin
    # should have proper admin check here
    if @user.username == "sam_the_owner"
      erb :"/users/admin"
    else
      # if the user is not admin - log them out and send them to splash page
      session.clear
      redirect "/" 
    end
  end

  get "/logout" do
    # logout = clear session and send to splash page
    session.clear
    redirect "/"
  end

  get "/users/:slug" do
    @user = User.find_by_slug(params[:slug])
    erb :"/users/index"
  end

  post "/users/new" do
    # create new user
    if !params.values.all?{|param| !param.empty?}
      # if any of the input fields are empty, reload new user form
      redirect "/errors/users/new"
    end
    # check to see if username or email are already users
    if (!!@user = User.find_by(username: params[:username])) || (!!@user = User.find_by(email: params[:email]))
      # if so - redirect to error page
      redirect "/errors/users/existing_user"
    end
    #create user and log in
    @user = User.new(params)
    @user.save
    session[:user_id] = @user.id
    # redirect to add a store to user
    erb :"/stores/new"
  end
   
  post "/login" do
    @user = User.find_by(username: params[:username])
    if @user == nil
      # if user does not exist - go to splash page
      redirect "/"
    elsif @user.username == "sam_the_owner" && @user.authenticate(params[:password])
      # check to see if user is admin and the password authenticates
      # if true redirect to admin page
      # should use proper admin check here
      session[:user_id] = @user.id
      redirect "/users/admin"
    elsif @user && @user.authenticate(params[:password])
      # if user exists and the password authenticates go to user index
      session[:user_id] = @user.id
      redirect "/users/index"
    end
  end
end
