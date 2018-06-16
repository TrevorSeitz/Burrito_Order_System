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
    @item_count = 0
    params[:burritos].each do |item|
      if item[:quantity].to_i > 0
        @item_count += 1
        # bring in current burrito element
        @burrito = Burrito.find_by_id(item[:id].to_i)
        # save each ordered burrito to order_burrito
        OrderBurrito.create(order_id: @order.id, user_id: @user.id, burrito_id: @burrito.id, quantity: item[:quantity].to_i, item_price: @burrito.price)
      end
    end
    if @item_count < 1
      erb :'/errors/orders/blank_order'
    end
    redirect "/orders/preview"
  end

  patch "/orders/edit" do
    item_count = 0
    @order = Order.find_by_id(@user.order_ids)
    # gather all items from order_burrito for this order
    @order_items = OrderBurrito.all.where(order_id:  @order.id)
    #  sort through the edited order 
    params[:burritos].each do |burrito|
      @burrito = Burrito.find_by_id(burrito[:id].to_i)
      if burrito[:quantity].to_i >0
        item_count += 1
      end
      @current_item = @order_items.where(burrito_id: burrito[:id].to_i)
      if @current_item == [] 
        if burrito[:quantity].to_i >0
          OrderBurrito.create(order_id: @order.id, user_id: @user.id, burrito_id: @burrito.id, quantity: burrito[:quantity].to_i, item_price: @burrito.price)
        end
      elsif @current_item[0].quantity != burrito[:quantity].to_i
        @current_item[0].quantity = burrito[:quantity].to_i
        @current_item[0].save
      end
    end
    if item_count < 1
      erb :'/errors/orders/blank_order'
    end
    redirect "/orders/preview"
  end

  post "/orders/complete" do
    redirect "/users/index"
  end
  
end
