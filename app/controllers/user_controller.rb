class UserController < ApplicationController

  get "/users" do
    @users = User.all

    erb :"users/index"
  end

  get "/users/new" do
    # sign up a new user
    if is_logged_in?
      # if the user is already logged in - don't allow them to see the "new user" page
      # instead, redirect to their store's index page
      redirect "/store/:id/index"
    else
      erb :"users/new"
  end

  get "/login" do
    # user login page
    if is_logged_in?
      # if the user is already logged in - don't allow them to see the "login" page
      # instead, redirect to their store's index page
      redirect "/store/:id/index"
    else
      erb :"/users/login"
  end

  get "/logout" do
    session.clear
    redirect "/users/login"
  end
end
