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
    # save order to orders table and to orders_burritos
    @order = Order.create(store_id: @store.id, user_id: @user.id)
    binding.pry
    # possibly create /orders/create control to create order and and save to tables
    # before allowing editing
    erb :"/orders/preview"
  end

  get '/orders/history' do
    erb :"orders/history"
  end

  post "/orders/preview" do
    params[:burritos].each do |item|
      if item[:quantity].to_i > 0
        redirect "/orders/preview"
      end
      erb :'/errors/orders/blank_order'
    end
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
