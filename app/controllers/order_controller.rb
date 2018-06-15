class OrderController < ApplicationController
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

  get "/orders/new" do
    @order = Order.new(store_id: @user.store_id, user_id: @user.id)
    @order.save
    # binding.pry
    @user.order_ids = @order.id
    @user.save
    erb :"/orders/new"
  end
  
  get "/orders/preview" do
    erb :"/orders/preview"
  end

  get '/orders/history' do
    erb :"orders/history"
  end

  post "/orders/preview" do
    # save order to orders table and to order_burrito
    @order = Order.create(store_id: @store.id, user_id: @user.id)
    params[:burritos].each do |item|
      if item[:quantity].to_i > 0
        # bring in current burrito element
        @burrito = Burrito.find_by_id(item[:id].to_i)
        # create new order
        OrderBurrito.create(order_id: @order.id, user_id: @user.id, burrito_id: @burrito.id, quantity: item[:quantity].to_i, item_price: @burrito.price)
        # redirect "/orders/preview"
      # binding.pry
      end
    end
    # binding.pry
    if OrderBurrito.last.order_id == @order.id
      redirect "/orders/preview"
    end
    erb :'/errors/orders/blank_order'
  end
# Create a single item - @item = Burrito.find_by_id(params[:burritos][id.to_i-1])
# Quantity of a burrito - params[:quantity][id.to_i-1]
# Item 

  post "/orders/complete" do
    binding.pry
    # do all the things needed to save
  end

  patch "/orders/edit" do
    binding.pry
    # do all the things needed to save/edit 
  end
end
