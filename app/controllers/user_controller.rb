require 'pry'
class UserController < ApplicationController

  get "/users" do
    @users = User.all
    redirect "/users/index"
    # erb :"/users/index"
  end

  get "/users/new" do
    # sign up a new user
    if is_logged_in?
      # if the user is already logged in - don't allow them to see the "new user" page
      # instead, redirect to their store's index page
      redirect "/users/index"
    else
      erb :"/users/new"
    end
  end

  get "/users/index" do
    erb :"/users/index"
  end

  get "/errors/users/new" do
    erb :"/errors/users/new"
  end

  get "/login" do
      binding.pry
        # user login page
    if is_logged_in?
      # if the user is already logged in - don't allow them to see the "login" page
      # instead, redirect to their store's index page
      redirect "/users/index"
    else
      redirect "/"
    end
  end

    get "/users/admin" do
      @user = User.find_by_id(session[:user_id])
      
      if @user.username == "sam_the_owner"
        erb :"/users/admin"
      else
        redirect "/" 
      end
    end

  get "/logout" do
    session.clear
    redirect "/"
  end

  get "/users/:slug" do
    @user = User.find_by_slug(params[:slug])
    erb :"/users/index"
  end

  post "/users/new" do
    if !params.values.all?{|param| !param.empty?}
      redirect "/errors/users/new"
    end
    if is_logged_in?
      redirect "/users/index"
    end
    if !!@user = User.find_by(email: params[:email])
      redirect "/login"
    end
    @user = User.new(params)
    @user.save
    session[:user_id] = @user.id
    erb :"/stores/new"
  end
   
  post "/login" do
    @user = User.find_by(username: params[:username])
    # binding.pry
    if @user.username == "sam_the_owner" && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "/users/admin"
    elsif @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "/users/index"
    else
      redirect "/errors/users/login"
    end
  end
end
