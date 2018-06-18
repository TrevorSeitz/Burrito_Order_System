class BurritoController < ApplicationController
  # this controller is/should only be accessed by admin
  before do
    # Check if User exists & is logged in
    if !current_user
      redirect "/"
    end
    # Create @user
    @user = User.find_by_id(session[:user_id])
    # Create @store
    @store = Store.find_by_id(@user.store_id)
  end
  
  get "/burritos/new" do 
    # should have proper admin check here
    if @user.username == "sam_the_owner"
    # go to new burrito form
    erb :"/burritos/new"
    else
      # got to burrito index
      redirect "/logout"
    end
  end

  get "/burritos/index" do
    @burritos = Burrito.all
    # go to list of burritos
    erb :"/burritos/index"
  end

  post "/burritos/new" do
    # receive new burrito form and save burrito to burrito table
    @burrito = Burrito.new(params)  
    @burrito.save
    redirect "/burritos/new"
  end
end
