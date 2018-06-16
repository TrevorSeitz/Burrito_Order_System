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
    @user.order_ids = @order.id
    @user.save
    erb :"/orders/new"
  end
  
  get "/orders/preview" do
    erb :"/orders/preview"
  end

  get "/orders/edit" do
    erb :"/orders/edit"
  end

  get '/orders/history' do
    erb :"orders/history"
  end

  get '/orders/:id' do
    @order = Order.find(params[:id])

    erb :'/orders/show'
  end

  post "/orders/preview" do
    @order = Order.find_by_id(@user.order_ids)
    # save order to orders table   
    # @user.order_ids = @order.id
    params[:burritos].each do |item|
      if item[:quantity].to_i > 0
        # bring in current burrito element
        @burrito = Burrito.find_by_id(item[:id].to_i)
        # save each ordered burrito to order_burrito
        OrderBurrito.create(order_id: @order.id, user_id: @user.id, burrito_id: @burrito.id, quantity: item[:quantity].to_i, item_price: @burrito.price)
      end
    end
    if OrderBurrito.last.order_id == @order.id
      redirect "/orders/preview"
    end
    erb :'/errors/orders/blank_order'
  end

  patch "/orders/edit" do
    binding.pry
    params[:burritos].each do |item|
      if item[:quantity].to_i > 0
        # bring in current burrito element
        @burrito = Burrito.find_by_id(item[:id].to_i)
        # create new order_burrito row
         OrderBurrito.update(order_id: @order.id, user_id: @user.id, burrito_id: @burrito.id, quantity: item[:quantity].to_i, item_price: @burrito.price)
      end
    end
    if OrderBurrito.last.order_id == @order.id
      redirect "/orders/preview"
    end
    erb :'/errors/orders/blank_order'
  end

  post "/orders/complete" do
    redirect "/users/index"
  end
  
end
