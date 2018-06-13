class BurritoController < ApplicationController
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
    # Create @store
    @store = Store.find_by_id(@user.store_id)
  end
  
  get "/burritos/new" do
    erb :"/burritos/new"
  end

  get '/burritos/index' do
    erb :"/burritos/index"
  end

  post "/burritos/new" do
    # binding.pry
    @burrito = Burrito.new(params)  
    @burrito.save
    redirect "/burritos/new"
  end
end
