class StoreController < ApplicationController

  get "/stores/new" do
    erb :"/stores/new"
  end

  post "/stores/new" do
    if !params.values.all?{|param| !param.empty?}
      redirect "/stores/new"
    end
    @user = User.find_by_id(session[:user_id])
    @store = Store.new(params)
    @store.save
    @user.store_id = @store.id
    @user.save 

    erb :"/users/index"
  end

end
