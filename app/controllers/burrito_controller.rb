class BurritoController < ApplicationController
  before do
    if !is_logged_in?
      # if the user is not logged in - go to login page
      redirect "/login"
    end
    if !!@user = User.find_by(email: params[:email])
      redirect "/login"
    end
    @user = User.find_by_id(session[:user_id])
    binding.pry
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
