class StoreController < ApplicationController
  before do
    # Check if User exists
    if !!@user = User.find_by(email: params[:email])
      redirect "/users/new"
    end
    # Check if User is Logged in
    if !is_logged_in?
      # if the user is not logged in - go to login page
      redirect "/login"
    end
    # Create @user
    @user = User.find_by_id(session[:user_id])
  end

  get "/stores/new" do
    erb :"/stores/new"
  end

  post "/stores/new" do
    if !params.values.all?{|param| !param.empty?}
      redirect "/stores/new"
    end
    @user = User.find_by_id(session[:user_id])
    @store = Store.new(params)
    @store.users_ids = @user.id
    @store.save
    @user.store_id = @store.id
    @user.save 
    erb :"/users/index"
  end

end
