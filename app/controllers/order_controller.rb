class OrderController < ApplicationController
  get "/orders/new" do
    erb :"/orders/new"
  end

  post "/orders/preview" do
    binding.pry
    if !is_logged_in?
      # if the user is not logged in - go to login page
      redirect "/login"
    end
    if !!@user = User.find_by(email: params[:email])
      redirect "/login"
    end
    binding.pry
  end

  post "/orders/new" do
  
  end
end
