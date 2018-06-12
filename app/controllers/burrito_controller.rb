class BurritoController < ApplicationController
  get "/burritos/new" do
    erb :"/burritos/new"
  end

  get '/burritos/index' do
    erb :"/burritos/index"
  end

  post "/burritos/new" do
    if !is_logged_in?
      # if the user is not logged in - go to login page
      redirect "/login"
    end
    if !!@user = User.find_by(email: params[:email])
      redirect "/login"
    end
    # binding.pry
    @burrito = Burrito.new(params)  
    @burrito.save
    redirect "/burritos/new"
  end
end
