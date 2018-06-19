class OrderController < ApplicationController
  
  before do
    # Check if User exists & is logged in
    if !current_user
      redirect "/"
    end
    # Create @user
    @user = User.find_by_id(session[:user_id])
    # Create @store
    @store = Store.find_by_id(@user.store_id)
  end

  get "/orders/new" do
    @burrito = Burrito.all
    # go to order form
    erb :"/orders/new"
  end
  
  get "/orders/preview" do
    # collect burritos for order
    @order = Order.find_by_id(@user.order_ids)
    @order_items = @order.burritos

    # preview order
    erb :"/orders/preview"
  end

  get "/orders/edit" do
    @order = Order.find_by_id(@user.order_ids)
    @burrito = Burrito.all
    @order_items = @order.burritos

    # edit the order
    erb :"/orders/edit"
  end

  get '/orders/history' do
    # collect the user's orders
    @orders = Order.all.find_all{|order| order["user_id"] == current_user.id }

    # show user's order history
    erb :"/orders/history"
  end

  get '/errors/orders/blank_order' do
    @burritos = Burrito.all
    erb :'/errors/orders/blank_order'
  end

  get '/orders/:id' do
    # show single order
    @order = Order.find(params[:id])
    @order_items = OrderBurrito.all.where(order_id:  params[:id].to_i)

    erb :'/orders/show'
  end

  post "/orders/new" do
    # set item count to 0 to ensure there are no empty orders
    @item_count = 0
    # create new order and assign store and user to it
    @order = Order.new(store_id: @user.store_id, user_id: @user.id)
    @order.save
    # assign new order id to user
    @user.order_ids = @order.id
    @user.save
    # save order to order_burrito table  
    params[:burritos].each do |burrito|
      if burrito[:quantity].to_i > 0
        # increase item_count if quantity is > 0
        @item_count += 1
        # bring in current burrito element
        @burrito = Burrito.find_by_id(burrito[:id].to_i)
        @burrito.quantity = burrito[:quantity].to_i
        @burrito.save
        # save each ordered burrito to order_burrito
        OrderBurrito.create(order_id: @order.id, user_id: @user.id, burrito_id: @burrito.id, quantity: @burrito.quantity, item_price: @burrito.price)
      end
      # if quantity is not > 0 go to next burrito
    end
    if @item_count < 1
      # if item count 0 - go to error for blank order
      redirect '/errors/orders/blank_order'
    end
    # otherwise go to preview page
    redirect "/orders/preview"
  end

  patch "/orders/edit" do
    # set item count to 0 to ensure there are no empty orders
    item_count = 0
        @order = Order.find_by_id(@user.order_ids)
    # delete old OrderBurrito items for this order_id
    OrderBurrito.where(order_id: @order.id).destroy_all  
    # sort through the edited order to update new quantities
    params[:burritos].each do |burrito|
      @burrito = Burrito.find_by_id(burrito[:id].to_i)
      @burrito.quantity = burrito[:quantity].to_i
      @burrito.save
      if burrito[:quantity].to_i >0
        # adding to item_count to check for 0 item order
        item_count += 1
        # create new OrderBurrito item for order item
        OrderBurrito.create(order_id: @order.id, user_id: @user.id, burrito_id: @burrito.id, quantity: @burrito.quantity, item_price: @burrito.price)
      end
    end
    # check for 0 order
    if item_count < 1
      # if the order now contains 0 items go to error page
      redirect '/errors/orders/blank_order'
    end
    # if order is ok - go to order confirmation/preview page
    redirect "/orders/preview"
  end
  
  post "/orders/complete" do
    # after user confirms order, remove order number from @user
    @user.order_ids = nil
    @user.save
    Burrito.all.each do |burrito|
      burrito.quantity = nil
      burrito.save
    end
    # go back to user index page
    redirect "/users/index"
  end
  
  delete '/order/:id' do
    # delete requested order and return to user index
    @order = Order.delete(params[:id])
    Burrito.all.each do |burrito|
      burrito.quantity = 0
      burrito.save
    end
    redirect "/users/index"
  end

end
