class StoreController < ApplicationController
  before do
    # Check if User exists & is logged in
    if !current_user
      redirect "/"
    end
    # Create @user
    @user = User.find_by_id(session[:user_id])
  end

  get "/stores/new" do
    # go to new store input page
    erb :"/stores/new"
  end

  post "/stores/new" do
    # check to ensure all ionput fields have content
    if !params.values.all?{|param| !param.empty?}
      # if not - reload page
      redirect "/stores/new"
    end
    @user = User.find_by_id(session[:user_id])
    # create new store
    @store = Store.new(params)
    @store.save
    # add store to user
    @user.store_id = @store.id
    @user.save 
    # go to user index
    erb :"/users/index"
  end

end
