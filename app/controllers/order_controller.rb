class OrderController < ApplicationController
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

  get "/orders/new" do
    @order = Order.new(store_id: @user.store_id, user_id: @user.id)
    @order.save
    @user.order_ids = @order.id
    @user.save
    erb :"/orders/new"
  end

  post "/orders/preview" do
    params[:burritos].each do |id|
    end
  end
# Create a single item - @item = Burrito.find_by_id(params[:burritos][id.to_i-1])
# Quantity of a burrito - params[:quantity][id.to_i-1]
# Item 

  post "/orders/new" do
  
  end
end
