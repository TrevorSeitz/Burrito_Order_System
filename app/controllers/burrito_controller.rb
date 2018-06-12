class BurritoController < ApplicationController
  get "/burritos/new" do
    erb :"/burritos/new"
  end

  post "/burritos/new" do
    if !is_logged_in?
      # if the user is not logged in - go to login page
      redirect "/login"
    end
    if !!@user = User.find_by(email: params[:email])
      redirect "/login"
    end
    @burrito = Burrito.new(params)  
    @user.save
    redirect "/burritos/new"
  end
end
